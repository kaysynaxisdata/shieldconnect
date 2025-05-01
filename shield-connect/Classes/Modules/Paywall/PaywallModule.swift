//
//  PaywallModule.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import Foundation

import Foundation
import UIKit
import Swinject
import SwiftUI

protocol PaywallModuleProtocol: PresentableSwiftUI {
    func configure(with input: PaywallModuleInput)
}

class PaywallModuleInput {
    
    var resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
}

final class PaywallModule: PaywallModuleProtocol {

    // Change from implicitly unwrapped optional to regular optional
    private var input: PaywallModuleInput?

    init() { }

    func configure(with input: PaywallModuleInput) {
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
        
        let viewModel = PaywallViewModel(input: input)
        let viewController = PaywallViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
