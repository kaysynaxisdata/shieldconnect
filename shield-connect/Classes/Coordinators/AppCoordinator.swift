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
        splashInput.didLoad = { [weak self] promoResponse in
            if let promoResponse = promoResponse {
                switch promoResponse.df {
                    case "as": self?.showPromo(promo: promoResponse)
                    case "cp": self?.showPromoTwo(promo: promoResponse)
                    default: self?.showSecurity()
                }
            } else {
                self?.showSecurity()
            }
        }
        let module = SplashModuleModule()
        module.configure(with: splashInput)
        self.navigationController.setViewControllers([module.toPresent], animated: false)
    }
    
    func showPromo(promo: PromoResponse) {
        let promoInput = PromoModuleInput(resolver: self.assembler.resolver, promo: promo)
        let module = PromoModule()
        module.configure(with: promoInput)
        let vc = module.toPresent
        promoInput.didFinish = { [weak self, weak vc] in
            vc?.dismiss(
                animated: true,
                completion: { [weak self] in
                    self?.showSecurity()
                }
            )
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(vc, animated: true)
    }
    
    func showPromoTwo(promo: PromoResponse) {
        let promoInput = PromoTwoModuleInput(resolver: self.assembler.resolver, promo: promo)
        let module = PromoTwoModule()
        module.configure(with: promoInput)
        let vc = module.toPresent
        promoInput.didFinish = { [weak self, weak vc] in
            vc?.dismiss(
                animated: true,
                completion: { [weak self] in
                    self?.showSecurity()
                }
            )
        }
        vc.modalPresentationStyle = .overCurrentContext
        self.navigationController.present(vc, animated: true)
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

