import Swinject
import UIKit

final class CoordinatorsAssembly: Assembly {
    func assemble(container: Container) {
        // App Coordinator
        container.register(AppCoordinator.self) { (r, navigationController: UINavigationController) in
            AppCoordinator(
                assembler: r.resolve(Assembler.self)!,
                navigationController: navigationController
            )
        }


//        container.register(SecureAccessCoordinator.self) { (r, navigationController: UINavigationController) in
//            SecureAccessCoordinator(
//                resolver: r,
//                navigationController: navigationController
//            )
//        }

    }
}
