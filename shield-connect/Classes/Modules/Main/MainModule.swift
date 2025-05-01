//
//  MainModule.swift
//  shield-connect
//
//  Created by Александр on 11.04.2025.
//

import Foundation
import UIKit
import Swinject
import SwiftUI

protocol MainModuleProtocol: PresentableSwiftUI {
    func configure(with input: MainModuleInput)
}

class MainModuleInput {
    
    var resolver: Resolver
    var didSelectCountry: Completion?
    var didSettingTap: Completion?
    var didSpeedCheckerTap: Completion?
    var didShowPaywall: Completion?
    var didSelectCountryId: ((String) -> Void)?
    
    init(resolver: Resolver) {
        self.resolver = resolver
    }
    
}

final class MainModule: MainModuleProtocol {
    
    // Change from implicitly unwrapped optional to regular optional
    private var input: MainModuleInput?

    init() { }

    func configure(with input: MainModuleInput) {
        self.input = input
    }
    
    var toPresentView: ViewType {
        return AnyView(
            Text("Module not configured")
                .foregroundColor(.red)
        )
//        guard let input = input else {
//            // Return a placeholder view if input is not configured
//            return AnyView(
//                Text("Module not configured")
//                    .foregroundColor(.red)
//            )
//        }
//        
//        let viewModel = PasscodeViewModel(input: input)
//        let view = PasscodeView(viewModel: viewModel)
//        return view
    }

    var toPresent: UIViewController {
        guard let input = input else {
            return UIViewController()
        }
        
        let viewModel = MainViewModel(input: input)
        let viewController = MainViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
