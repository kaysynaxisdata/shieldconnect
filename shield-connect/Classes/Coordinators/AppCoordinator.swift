import UIKit
import Swinject
import Combine

final class AppCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    private let assembler: Assembler
    private var resetAppCancellation: AnyCancellable?

    init(
        assembler: Assembler,
        navigationController: UINavigationController
    ) {
        self.assembler = assembler
        self.navigationController = navigationController
    }

    func start() {
        showSplashFlow()
    }
    
    func showSplashFlow() {
        let splashInput = SplashModuleInput(resolver: self.assembler.resolver)
        splashInput.didLoad = { [weak self] in
            self?.showSecurity()
        }
        let module = SplashModuleModule()
        module.configure(with: splashInput)
        self.navigationController.setViewControllers([module.toPresent], animated: false)
    }
    
    func showSecurity() {
        let securityCoordinator = SecurityCoordinator(
            resolver: self.assembler.resolver,
            navigationController: self.navigationController
        )
        addChildCoordinator(securityCoordinator)
        securityCoordinator.didEnd = { [weak self] in
            self?.removeChildCoordinator(securityCoordinator)
            self?.showMain()
        }
        securityCoordinator.start()
    }
    
    func showMain() {
        let mainCoordinator = MainCoordinator(
            resolver: self.assembler.resolver,
            navigationController: self.navigationController
        )
        addChildCoordinator(mainCoordinator)
        mainCoordinator.start()
    }
    
    func finish() {}
}

