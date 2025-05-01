//
//  StorageService.swift
//  shield-connect
//
//  Created by Александр on 11.04.2025.
//

import Foundation

protocol StorageService {
    
    var isPasscodeInstall: Bool { get }
    var isFaceIDInstall: Bool { get }
    var servers: [ServerCountry] { get set }
    var currentServerID: String? { get set }
    
    func resetPasscode()
    func savePasscode(code: String)
    func compare(code: String) -> Bool
    func faceIDsetEnable(_ enable: Bool)
}

class StorageServiceImplementation: StorageService {
    
    @UserDefaultsWrapper(key: "passcode")
    private var passcode: String?
    @UserDefaultsWrapper(key: "isUseFaceID")
    private var isUseFaceID: Bool?
    @UserDefaultsWrapper(key: "currentServerID")
    var currentServerID: String?
    
    var servers: [ServerCountry] = []
    
    var isPasscodeInstall: Bool {
        return passcode != nil
    }
    
    var isFaceIDInstall: Bool {
        if let isUseFaceID = isUseFaceID, isUseFaceID == true {
            return true
        }
        return false
    }
    
    func savePasscode(code: String) {
        self.passcode = code
    }
    
    func resetPasscode() {
        self.passcode = nil
    }
    
    func compare(code: String) -> Bool {
        if self.passcode == code, code.isEmpty == false {
            return true
        }
        
        return false
    }
    
    func faceIDsetEnable(_ enable: Bool) {
        self.isUseFaceID = enable
    }
    
}
