//
//  Extension+Toastable.swift
//  shield-connect
//
//  Created by Александр on 18.04.2025.
//

import Foundation
import UIKit
import Toast

protocol Toastable {
    func showToast(message: String)
}

extension Toastable where Self: UIViewController {
    
    func showToast(message: String) {
        self.view.makeToast(message, duration: 3.0, position: .top)
    }
    
}
