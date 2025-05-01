//
//  ServersViewModel.swift
//  shield-connect
//
//  Created by Александр on 12.04.2025.
//

import Foundation

class ServersViewModel: ObservableObject {
    
    var input: ServersModuleInput
    
    var servers: [ServerCountry]
    var storageService: StorageService
    var selectServer: String?
    
    init(input: ServersModuleInput) {
        self.input = input
        self.storageService = input.resolver.resolve(StorageService.self)!
        self.servers = self.storageService.servers
        self.selectServer = self.storageService.currentServerID
    }
    
    func didSelectServer(id: String) {
        self.selectServer = id
        self.input.didSelect?(id)
    }
    
}
