//
//  PaywallViewModel.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import UIKit

class PaywallViewModel {
    
    enum PatwallButtonTap {
        case terms
        case privacy
        case restore
    }
    
    var didUpdateUI: Completion?
    var didDismiss: Completion?
    var didLoading: ((Bool) -> Void)?
    var didShowError: ((String) -> Void)?
    var input: PaywallModuleInput
    
    private var storeService: StoreService
    var dipslayProducts: [ProductDTO] {
//        let p = [ProductDTO(id: "1"),
//                 ProductDTO(id: "2")]
//        return p
        return self.storeService.displayProducts
    }
    var currentProduct: ProductDTO? {
        didSet {
            self.didUpdateUI?()
        }
    }
    
    init(input: PaywallModuleInput) {
        self.input = input
        self.storeService = input.resolver.resolve(StoreService.self)!
        self.currentProduct = self.dipslayProducts.first
    }
    
    func viewDidLoad() {
        self.currentProduct = self.dipslayProducts.first
        self.storeService.didUpdate = { [weak self] in
            if self?.storeService.hasUnlockedPro == true {
                self?.didDismiss?()
            }
        }
    }
    
    func selectProductTapped(productId: String) {
        self.currentProduct = self.dipslayProducts.first(where: { $0.id == productId })
    }
    
    func didTap(state: PatwallButtonTap) {
        switch state {
            case .restore:
                self.storeService.restore { errorString in
                    //
                }
            case .privacy:
                UIApplication.shared.open(URL(string: Constants.URLs.privacy)!)
            case .terms:
                UIApplication.shared.open(URL(string: Constants.URLs.terms)!)
        }
    }
    
    func payTapped() {
        if let currentProduct = self.currentProduct {
            self.didLoading?(true)
            self.storeService.pay(
                productId: currentProduct.id,
                completion: { [weak self] errorString in
                    DispatchQueue.main.async {
                        self?.didLoading?(false)
                        if let errorString = errorString {
                            self?.didShowError?(errorString)
                        }
                    }
                }
            )
        }
    }
    
    func restore() {
        self.storeService.restore { errorString in
            DispatchQueue.main.async {
                if let errorString = errorString {
                    self.didShowError?(errorString)
                } else {
                    self.didShowError?("Restore success")
                }
            }
        }
    }
    
}
