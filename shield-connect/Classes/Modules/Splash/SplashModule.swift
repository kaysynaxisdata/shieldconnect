//
//  SplashModule.swift
//  shield-connect
//
//  Created by Александр on 29.03.2025.
//

import Foundation
import SwiftUI

typealias ViewType = any View

protocol Presentable: AnyObject {
    var toPresent: UIViewController { get }
}

protocol PresentableSwiftUI: Presentable {
    var toPresentView: ViewType { get }
}

// MARK: - Presentable
//extension Presentable {
//    func makeHostingViewController(rootView: some View) -> UIViewController {
//        let hostingController = UIHostingController(rootView:  rootView.navigationBarBackButtonHidden())
//        hostingController.modalPresentationStyle = .fullScreen
//        return hostingController
//    }
//}


protocol SplashModuleProtocol: PresentableSwiftUI {
    func configure(with input: SplashModuleInput)
}

final class SplashModuleModule: SplashModuleProtocol {
    // Change from implicitly unwrapped optional to regular optional
    private var input: SplashModuleInput?

    init() { }

    func configure(with input: SplashModuleInput) {
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
        
        let viewModel = SplashViewModel(input: input)
        let view = SplashViewController()
        view.viewModel = viewModel
        return view
    }
}
