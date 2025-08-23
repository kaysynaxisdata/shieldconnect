import Swinject
import UIKit

final class ServicesAssembly: Assembly {
    func assemble(container: Container) {

        // Network
        container.register(APINetworkServiceInterface.self) { _ in
            APINetworkService()
        }
        .inObjectScope(.container)

        // Storages
        container.register(StorageService.self) { _ in
            StorageServiceImplementation()
        }
        .inObjectScope(.container)
//
        
        // Store
        container.register(StoreService.self) { r in
            StoreServiceImplementation(storageService: r.resolve(StorageService.self)!)
        }
        .inObjectScope(.container)
        
        // Store
        container.register(APINetworkService.self) { _ in
            APINetworkService()
        }
        .inObjectScope(.container)
        
        // Speed
        container.register(SpeedServiceInterface.self) { _ in
            SpeedService()
        }
        .inObjectScope(.container)
        
//
//        // Secure Access Service
//        container.register(SecureAccessServiceInterface.self) { r in
//            SecureAccessService(
//                storageService: r.resolve(StorageServiceInterface.self)!,
//                firebaseService: r.resolve(FirebaseServiceInterface.self)!
//            )
//        }
//        .inObjectScope(.container)
    }
}
