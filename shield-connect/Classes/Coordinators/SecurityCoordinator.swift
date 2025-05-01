//
//  SecurityCoordinator.swift
//  shield-connect
//
//  Created by Александр on 11.04.2025.
//

import Foundation
import UIKit
import Swinject

final class SecurityCoordinator: Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController

    var didEnd: Completion?
    
    private let resolver: Resolver
    private var storage: StorageService

    init(
        resolver: Resolver,
        navigationController: UINavigationController
    ) {
        self.resolver = resolver
        self.navigationController = navigationController
        self.storage = resolver.resolve(StorageService.self)!
    }

    func start() {
        if self.storage.isPasscodeInstall {
            showEnterPasscode()
        } else {
            showSetupPasscode()
        }
    }
    
    func reset() {
        self.storage.resetPasscode()
        self.showSetupPasscode()
    }
    
    func showSetupPasscode() {
        let input = PasscodeModuleInput(
            resolver: self.resolver,
            state: .setup
        )
        let module = PasscodeModule()
        module.configure(with: input)
        let vc = module.toPresent
        input.didEnd = { [weak self] state in
            vc.dismiss(
                animated: false,
                completion: { [weak self] in
                    self?.start()
                }
            )
        }
        vc.modalPresentationStyle = .fullScreen
        self.navigationController.present(vc, animated: true)
    }
    
    func showEnterPasscode() {
        let input = PasscodeModuleInput(
            resolver: self.resolver,
            state: .enter
        )
        let module = PasscodeModule()
        module.configure(with: input)
        let vc = module.toPresent
        input.didEnd = { [weak self] state in
            self?.didEnd?()
            vc.dismiss(animated: true)
        }
        vc.modalPresentationStyle = .fullScreen
        self.navigationController.present(vc, animated: true)
    }
    
    func finish() {}
}

