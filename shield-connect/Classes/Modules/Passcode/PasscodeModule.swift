//
//  PasscodeModule.swift
//  shield-connect
//
//  Created by Александр on 11.04.2025.
//

import Foundation
import UIKit
import Swinject
import SwiftUI

protocol PasscodeModuleProtocol: PresentableSwiftUI {
    func configure(with input: PasscodeModuleInput)
}

class PasscodeModuleInput {
    
    var didEnd: ((PasscodeState) -> Void)?
    var state: PasscodeState
    var resolver: Resolver
    
    init(resolver: Resolver, state: PasscodeState) {
        self.resolver = resolver
        self.state = state
    }
    
}

final class PasscodeModule: PasscodeModuleProtocol {
    
    // Change from implicitly unwrapped optional to regular optional
    private var input: PasscodeModuleInput?

    init() { }

    func configure(with input: PasscodeModuleInput) {
        self.input = input
    }
    
    var toPresentView: ViewType {
        guard let input = input else {
            // Return a placeholder view if input is not configured
            return AnyView(
                Text("Module not configured")
                    .foregroundColor(.red)
            )
        }
        
        let viewModel = PasscodeViewModel(input: input)
        let view = PasscodeView(viewModel: viewModel)
        return view
    }

    var toPresent: UIViewController {
        guard let input = input else {
            return UIViewController()
        }
        
        let viewModel = PasscodeViewModel(input: input)
        let viewController  = PasscodeViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
