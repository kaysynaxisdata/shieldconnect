//
//  PromoTwoViewModel.swift
//  shield-connect
//
//  Created by Александр on 04.09.2025.
//

import Foundation

protocol PromoTwoViewModel {
    var promo: PromoResponse { get set }
    var didLoading: ((Bool) -> Void)? { get set }
    var didShowError: ((String) -> Void)? { get set }
    var lines: [SecurityCheckLine] { get set } 
    
    func viewDidLoad()
    func actionButtonTapped()
}

class PromoTwoViewModelImplementation: PromoTwoViewModel {
    
    var didLoading: ((Bool) -> Void)?
    var didShowError: ((String) -> Void)?
    
    var input: PromoTwoModuleInput
    var storeService: StoreService
    var networkService: APINetworkService
    var storageService: StorageService
    var promo: PromoResponse
    var lines: [SecurityCheckLine]
    
    init(input: PromoTwoModuleInput) {
        self.input = input
        self.storeService = input.resolver.resolve(StoreService.self)!
        self.networkService = input.resolver.resolve(APINetworkService.self)!
        self.storageService = input.resolver.resolve(StorageService.self)!
        self.promo = input.promo
        self.lines = input.promo.lines ?? []
    }
    
    func payTapped() {
        self.didLoading?(true)
        self.storeService.pay(
            productId: self.promo.productId,
            completion: { [weak self] errorString in
                
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.didLoading?(false)
                    if let errorString = errorString {
                        self.didShowError?(errorString)
                    } else {
                        Task {
                            do {
                                let paywall = self.promo.df ?? "unknown"
                                let _ = try await self.networkService.application.notify(
                                    acc: self.storageService.accToken,
                                    paywall: paywall
                                )
                            }
                        }
                    }
                }
            }
        )
    }
    
}


extension PromoTwoViewModelImplementation {
    
    func viewDidLoad() {
        self.storeService.didUpdate = { [weak self] in
            if self?.storeService.hasUnlockedPro == true {
                self?.input.didFinish?()
            }
        }
    }
    
    func actionButtonTapped() {
        self.payTapped()
    }
    
}
