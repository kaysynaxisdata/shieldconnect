//
//  ServersModule.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//


import Foundation
import UIKit
import Swinject
import SwiftUI

protocol ServersModuleProtocol: PresentableSwiftUI {
    func configure(with input: ServersModuleInput)
}

class ServersModuleInput {
    
    var didSelect: ((String) -> Void)?
    var resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
}

final class ServersModule: ServersModuleProtocol {
    
    // Change from implicitly unwrapped optional to regular optional
    private var input: ServersModuleInput?

    init() { }

    func configure(with input: ServersModuleInput) {
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
        
        let viewModel = ServersViewModel(input: input)
        let viewController = ServersViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
