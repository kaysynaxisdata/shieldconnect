//
//  SettingsModule.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import Foundation
import UIKit
import Swinject
import SwiftUI

protocol SettingsModuleProtocol: PresentableSwiftUI {
    func configure(with input: SettingsModuleInput)
}

class SettingsModuleInput {
    
    var didChangePasscode: Completion?
    var didOpenSupport: Completion?
    var didSelectPaywall: Completion?
    var resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
}

final class SettingsModule: SettingsModuleProtocol {
    
    // Change from implicitly unwrapped optional to regular optional
    private var input: SettingsModuleInput?

    init() { }

    func configure(with input: SettingsModuleInput) {
        self.input = input
    }
    
    var toPresentView: ViewType {
        return AnyView(
            Text("Module not configured")
                .foregroundColor(.red)
        )
    }

    var toPresent: UIViewController {
        guard let input = input else {
            return UIViewController()
        }
        
        let viewModel = SettingsViewModel(input: input)
        let viewController = SettingsViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
