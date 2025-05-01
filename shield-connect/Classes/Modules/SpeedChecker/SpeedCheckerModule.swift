//
//  SpeedCheckerModule.swift
//  shield-connect
//
//  Created by Александр on 13.04.2025.
//

import Foundation
import UIKit
import Swinject
import SwiftUI

protocol SpeedCheckerModuleProtocol: PresentableSwiftUI {
    func configure(with input: SpeedCheckerModuleInput)
}

class SpeedCheckerModuleInput {
    
    var didSelectPaywall: Completion?
    var resolver: Resolver
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
}

final class SpeedCheckerModule: SpeedCheckerModuleProtocol {
    
    // Change from implicitly unwrapped optional to regular optional
    private var input: SpeedCheckerModuleInput?

    init() { }

    func configure(with input: SpeedCheckerModuleInput) {
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
        
        let viewModel = SpeedCheckerViewModel(input: input)
        let viewController = SpeedCheckerViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
