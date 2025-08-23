//
//  PromoModule.swift
//  shield-connect
//
//  Created by Александр on 22.08.2025.
//

import Foundation

import Foundation
import UIKit
import Swinject


class PromoModuleInput {
    
    var resolver: Resolver
    var promo: PromoResponse
    var didFinish: Completion?
    
    init(resolver: Resolver, promo: PromoResponse) {
        self.promo = promo
        self.resolver = resolver
    }
    
}

final class PromoModule {

    private var input: PromoModuleInput?

    init() { }

    func configure(with input: PromoModuleInput) {
        self.input = input
    }

    var toPresent: UIViewController {
        guard let input = input else {
            return UIViewController()
        }
        
        let viewModel = PromoViewModelImplementation(input: input)
        let viewController = PromoViewController()
        viewController.viewModel = viewModel
        return viewController
    }
}
