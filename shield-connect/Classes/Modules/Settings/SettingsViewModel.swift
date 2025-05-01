//
//  SettingsViewModel.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import Foundation
import UIKit

class SettingsViewModel: ObservableObject {
    
    var input: SettingsModuleInput
    var groups: [SettingGroup]
    var faceIdEnable: Bool {
        return self.storageService.isFaceIDInstall
    }
    
    private var storageService: StorageService
    
    init(input: SettingsModuleInput) {
        self.input = input
        self.storageService = input.resolver.resolve(StorageService.self)!
        
        let profile = SettingGroup(
            items: [.faceId, .changePasscode],
            title: "Profile settings"
        )
        let support = SettingGroup(
            items: [.contactUs],
            title: "Support"
        )
        let about = SettingGroup(
            items: [.termsOfUse, .privacyPolicy],
            title: "About"
        )
        
        groups = [profile, support, about]
    }
    
    func paywallBannerTapped() {
        self.input.didSelectPaywall?()
    }
    
    func didSelect(indexPath: IndexPath) {
        let items = self.groups[indexPath.section]
        let item = items.items[indexPath.row]
        
        switch item {
        case .privacyPolicy:
            UIApplication.shared.open(URL(string: Constants.URLs.privacy)!)
        case .termsOfUse:
            UIApplication.shared.open(URL(string: Constants.URLs.terms)!)
        case .contactUs:
            self.input.didOpenSupport?()
        case .changePasscode:
            self.input.didChangePasscode?()
        default:
            break
        }
    }
    
    func faceIdSwitched() {
        self.storageService.faceIDsetEnable(!self.storageService.isFaceIDInstall)
    }
    
}
