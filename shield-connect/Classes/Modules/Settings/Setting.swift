//
//  Setting.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import Foundation
import UIKit

enum Setting: CaseIterable {
    case faceId
    case changePasscode
    
    case contactUs
    
    case privacyPolicy
    case termsOfUse
    
    var icon: UIImage? {
        switch self {
        case .faceId:
            return Asset.settingFaceid.image
        case .changePasscode:
            return Asset.settingRefresh.image
        case .contactUs:
            return Asset.settingChat.image
        case .privacyPolicy:
            return Asset.settingCompass.image
        case .termsOfUse:
            return Asset.settingFolder.image
        }
    }
    
    var title: String {
        switch self {
        case .faceId:
            return "Face ID"
        case .changePasscode:
            return "Change pasccode"
        case .contactUs:
            return "Contact Us"
        case .privacyPolicy:
            return "Privacy Policy"
        case .termsOfUse:
            return "Terms of use"
        }
    }
    
    var color: UIColor {
        switch self {
        case .faceId:
            return Asset.mainText.color
        case .changePasscode:
            return #colorLiteral(red: 0.1087977216, green: 0.7273144126, blue: 0.4686922431, alpha: 1)
        case .contactUs:
            return Asset.mainText.color
        case .privacyPolicy:
            return #colorLiteral(red: 0.1087977216, green: 0.7273144126, blue: 0.4686922431, alpha: 1)
        case .termsOfUse:
            return #colorLiteral(red: 0.1087977216, green: 0.7273144126, blue: 0.4686922431, alpha: 1)
        }
    }
}

struct SettingGroup {
    var items: [Setting]
    var title: String
}
