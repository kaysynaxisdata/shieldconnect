//
//  Extension+UIDevice.swift
//  shield-connect
//
//  Created by Александр on 13.04.2025.
//

import Foundation
import UIKit

extension UIScreen {
    
    static var isSmall: Bool {
        return UIScreen.main.bounds.height <= 667 
    }
    
}
