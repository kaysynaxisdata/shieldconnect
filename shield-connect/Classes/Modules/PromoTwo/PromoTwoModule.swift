//
//  PromoTwoModule.swift
//  shield-connect
//
//  Created by Александр on 04.09.2025.
//

import Foundation

import Foundation
import UIKit
import Swinject


class PromoTwoModuleInput {
    
    var resolver: Resolver
    var promo: PromoResponse
    var didFinish: Completion?
    
    init(resolver: Resolver, promo: PromoResponse) {
        self.promo = promo
        self.resolver = resolver
    }
    
}

final class PromoTwoModule {

    private var input: PromoTwoModuleInput?

    init() { }

    func configure(with input: PromoTwoModuleInput) {
        self.input = input
    }

    var toPresent: UIViewController {
        guard let input = input else {
            return UIViewController()
        }
        
        let viewModel = PromoTwoViewModelImplementation(input: input)
        let viewController = PromoTwoViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
