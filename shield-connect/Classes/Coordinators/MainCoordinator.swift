//
//  MainCoordinator.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import Foundation
import UIKit
import Swinject
import MessageUI

final class MainCoordinator: NSObject, Coordinator {
    var childCoordinators: [Coordinator] = []
    var navigationController: UINavigationController
    
    private let resolver: Resolver

    init(
        resolver: Resolver,
        navigationController: UINavigationController
    ) {
        self.resolver = resolver
        self.navigationController = navigationController
    }

    func start() {
        showMain()
    }
    
    var mainModuleInput: MainModuleInput?
    func showMain() {
        let input = MainModuleInput(resolver: self.resolver)
        input.didSelectCountry = { [weak self] in
            self?.showServers()
        }
        input.didSettingTap = { [weak self] in
            self?.showSettings()
        }
        input.didSpeedCheckerTap = { [weak self] in
            self?.showSpeedCheck()
        }
        input.didShowPaywall = { [weak self] in
            self?.showPaywall()
        }
        let module = MainModule()
        module.configure(with: input)
        self.mainModuleInput = input
        self.navigationController.setViewControllers([module.toPresent], animated: false)
    }
    
    func showServers() {
        let input = ServersModuleInput(resolver: self.resolver)
        let module = ServersModule()
        input.didSelect = { [weak self] id in
            self?.mainModuleInput?.didSelectCountryId?(id)
            self?.navigationController.popViewController(animated: true)
        }
        module.configure(with: input)
        self.navigationController.pushViewController(module.toPresent, animated: true)
    }
    
    func showSettings() {
        let input = SettingsModuleInput(resolver: self.resolver)
        input.didSelectPaywall = { [weak self] in
            self?.showPaywall()
        }
        input.didChangePasscode = { [weak self] in
            self?.showChangePasscode()
        }
        input.didOpenSupport = { [weak self] in
            self?.openMailbox(email: Constants.URLs.support)
        }
        let module = SettingsModule()
        module.configure(with: input)
        self.navigationController.pushViewController(module.toPresent, animated: true)
    }
    
    func showSpeedCheck() {
        let input = SpeedCheckerModuleInput(resolver: self.resolver)
        input.didSelectPaywall = { [weak self] in
            self?.showPaywall()
        }
        let module = SpeedCheckerModule()
        module.configure(with: input)
        self.navigationController.pushViewController(module.toPresent, animated: true)
    }
    
    func showPaywall() {
        let input = PaywallModuleInput(resolver: self.resolver)
        let module = PaywallModule()
        module.configure(with: input)
        let vc = module.toPresent
        vc.modalPresentationStyle = .fullScreen
        self.navigationController.present(vc, animated: true)
    }
    
    func showChangePasscode() {
        let secureCoordinator = SecurityCoordinator(
            resolver: self.resolver,
            navigationController: self.navigationController
        )
        secureCoordinator.reset()
        secureCoordinator.didEnd = { [weak self] in
            self?.removeChildCoordinator(secureCoordinator)
        }
        addChildCoordinator(secureCoordinator)
    }
    
    private func openMailbox(email: String) {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.mailComposeDelegate = self
            mail.setToRecipients([email])
            self.navigationController.present(mail, animated: true)
        }
    }
    
    func finish() {}
}

extension MainCoordinator: MFMailComposeViewControllerDelegate {
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
        controller.dismiss(animated: true)
    }
    
}
