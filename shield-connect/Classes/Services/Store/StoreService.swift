//
//  StoreService.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import Foundation
import StoreKit
import Adapty

struct ProductDTO {
    var id: String
    var name: String
    var description: String
    var localizedPrice: String
    var salePrice: String?
    var sale: Int?
    var trialDays: Int
    
    private var product: Product?
    
    init(product: Product) {
        self.product = product
        self.id = product.id
        self.description = product.description
        
        if product.description.isEmpty == false, let n = NumberFormatter().number(from: product.description) {
            let sale = CGFloat(truncating: n)
            let price = product.price / Decimal(sale)
            let formatter = NumberFormatter()
            formatter.locale = Locale.current // Change this to another locale if you want to force a specific locale, otherwise this is redundant as the current locale is the default already
            formatter.numberStyle = .currency
            if let formattedTipAmount = formatter.string(from: price as NSNumber) {
                salePrice = "\(formattedTipAmount)/month"
            }
        }
        
        self.localizedPrice = product.displayPrice
        self.name = product.displayName
        
        if let offer = product.subscription?.introductoryOffer?.period.value {
            self.trialDays = offer
        } else {
            self.trialDays = 0
        }
        
    }
    
    init(id: String, name: String, price: String, description: String, trialDays: Int) {
        self.id = id
        self.description = description
        self.localizedPrice = price
        self.name = name
        self.trialDays = trialDays
    }
    
    init(id: String) {
        self.id = id
        self.description = "Monthly Subscription"
        self.localizedPrice = "99.99$"
        self.salePrice = "4.7$/month"
        self.name = "Billed Monthly "
        self.trialDays = 0
    }
    
    var saleString: String? {
        if let sale = self.sale, sale > 0 {
            return "Save" + " " + "\(sale)" + "%"
        }
        
        return nil
    }
}

public enum PurchaseResult {
    case success(VerificationResult<Transaction>)
    case userCancelled
    case pending
}

enum MyError: Error {
    case userCanceled
    case unknown
}

protocol StoreService {
    
    var displayProducts: [ProductDTO] { get }
    var hasUnlockedPro: Bool { get }
    var didUpdate: Completion? { get set }
    
    func loadProducts() async throws
    func restore(completion: ((String?) -> Void)?)
    func pay(productId: String, completion: ((String?) -> Void)?)
    
}

class StoreServiceImplementation: NSObject, StoreService {

    var displayProducts: [ProductDTO] {
        
//        let week = ProductDTO(id: "com.shieldvpn.shieldconnect.week", name: "Week", price: "23", description: "3 day trial", trialDays: 3)
//        let months = ProductDTO(id: "com.shieldvpn.shieldconnect.month", name: "Month", price: "23", description: "2323", trialDays: 0)
//        
//        return [week, months]
        
        return products.map { product in
            let p = ProductDTO(
                product: product
            )
            return p
        }
    }
    private var productIds = Constants.Subscriptions.productIds
    private var products: [Product] = []
    private var productsLoaded = false
    private var updates: Task<Void, Never>? = nil
    private var storageService: StorageService
    
    var didUpdate: Completion?

    var purchasedProductIDs = Set<String>() {
        didSet {
            self.didUpdate?()
        }
    }

    var hasUnlockedPro: Bool {
        return !self.purchasedProductIDs.isEmpty
    }
    
    init(storageService: StorageService) {
        self.storageService = storageService
        super.init()
        self.updates = observeTransactionUpdates()
        
        Task {
            await self.updatePurchasedProducts()
        }
    }

    func loadProducts() async throws {
        guard !self.productsLoaded else { return }
                
        do {
            let product = try await Product.products(for: productIds)
            self.products = productIds.compactMap { id in
                product.first { $0.id == id }
            }
            self.productsLoaded = true
        } catch {
            debugPrint("Error: \(error)")
            throw error
        }
    }
    
    func pay(productId: String, completion: ((String?) -> Void)?) {
        guard let product = self.products.first(where: { $0.id == productId }) else {
            print("Product with ID \(productId) not found")
            completion?("Product with ID \(productId) not found")
            return
        }
        Task {
            do {
                try await self.purchase(product)
                completion?(nil)
            } catch {
                completion?(error.localizedDescription)
                print("Ошибка оплаты: \(error)")
            }
        }
    }
    
    private func purchase(_ product: Product) async throws {
        do {
            
            var result: Product.PurchaseResult
            if let token = UUID(uuidString: self.storageService.accToken) {
                result = try await product.purchase(options: [
                    .appAccountToken(token)
                ])
            } else {
                result = try await product.purchase()
            }

//            let result = try await product.purchase()
            switch result {
            case .success(let verificationResult):
                let transaction = try checkVerified(verificationResult)
                await self.updatePurchasedProducts()
                await transaction.finish()
                
                // ✅ Отправляем инфу о покупке в Adapty
//                Adapty.makePurchase(product: <#T##any AdaptyPaywallProduct#>)
//                Adapty.logPurchase(productId: product.id,
//                                   variationId: nil,
//                                   price: product.price,
//                                   currencyCode: product.priceFormatStyle.currency?.identifier ?? "USD") { result in
//                    if case let .failure(error) = result {
//                        print("Adapty логирование покупки не удалось: \(error)")
//                    }
//                }
            case .userCancelled:
                debugPrint("Cancel")
                throw MyError.userCanceled
            case .pending:
                debugPrint("Waiting")
            @unknown default:
                debugPrint("Unknown")
                throw MyError.unknown
            }
        } catch {
            debugPrint("error: \(error)")
            throw error
        }
    }
    
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .verified(let transaction):
            return transaction
        case .unverified(_, let error):
            debugPrint("error check transaction: \(error)")
            throw error
        }
    }
    
    @MainActor
    func updatePurchasedProducts() async {
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.revocationDate == nil {
                purchasedProductIDs.insert(transaction.productID)
            } else {
                purchasedProductIDs.remove(transaction.productID)
            }
        }
    }
    
    private func observeTransactionUpdates() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            for await _ in Transaction.updates {
                await self.updatePurchasedProducts()
            }
        }
    }
    
    func restore(completion: ((String?) -> Void)?) {
        Task {
            do {
                try await AppStore.sync()
                completion?(nil)
            } catch {
                completion?(error.localizedDescription)
            }
        }
    }
    
    deinit {
        updates?.cancel()
    }
    
}
