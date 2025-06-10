//
//  SplashViewModel.swift
//  shield-connect
//
//  Created by Александр on 29.03.2025.
//

import Foundation
import Combine
import Swinject

class SplashModuleInput {
    var didLoad: Completion?
    var resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
}

final class SplashViewModel: ObservableObject {

    // MARK: - Private Properties
    private let input: SplashModuleInput
    private var storeService: StoreService
    private var storageService: StorageService
    private var apiService: APINetworkService
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Public Properties

    // MARK: - Initialization
    init(
        input: SplashModuleInput
    ) {
        self.input = input
        self.storeService = input.resolver.resolve(StoreService.self)!
        self.storageService = input.resolver.resolve(StorageService.self)!
        self.apiService = input.resolver.resolve(APINetworkService.self)!
    }

    // MARK: - Private Methods
    private func setupBindings() {
    }
    
    func loadConfig(completion: (([ServerCountry]) -> Void)?) {
        
    }
    
    func viewDidLoad() {
        Task {
            do {
                async let servers = try await self.apiService.application.servers()
                try await self.storeService.loadProducts()
                self.storageService.servers = try await servers
                await MainActor.run {
                    self.input.didLoad?()
                }
            } catch (let error) {
                await MainActor.run {
                    self.input.didLoad?()
                }
                print(error)
            }
        }
        
    }
    

}
