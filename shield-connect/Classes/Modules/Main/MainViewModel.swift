//
//  MainViewModel.swift
//  shield-connect
//
//  Created by Александр on 11.04.2025.
//

import Foundation
import NetworkExtension
import UIKit

class MainViewModel: ObservableObject {
    
    private var input: MainModuleInput
    
    private var apiService: APINetworkService
    private var storeService: StoreService
    private var storageService: StorageService
    private var speedService: SpeedServiceInterface
    
    private var creds: Country? {
        didSet {
            self.didUpdate?(self.creds)
        }
    }
    var didUpdate: ((Country?) -> Void)?
    var didChangeStatus: ((ConnectViewState) -> Void)?
    var didShowError: ((String) -> Void)?
    var didCheckSpeed: ((String, String) -> Void)?
    
    init(input: MainModuleInput) {
        self.input = input
        self.apiService = input.resolver.resolve(APINetworkService.self)!
        self.storeService = input.resolver.resolve(StoreService.self)!
        self.storageService = input.resolver.resolve(StorageService.self)!
        self.speedService = input.resolver.resolve(SpeedServiceInterface.self)!
    }
    
    func viewDidLoad() {
        _ = VPNManager.shared
        vpnStateChanged(status: VPNManager.shared.status)
        VPNManager.shared.statusEvent.attach(self, MainViewModel.vpnStateChanged)
        getCurrentServer()
        
        self.input.didSelectCountryId = { [weak self] id in
            guard let strongSelf = self else { return }
            
            self?.storageService.currentServerID = id
            
            Task {
                do {
                    let creds = try await strongSelf.apiService.application.creds(id: id)
                    strongSelf.creds = creds
                    
                    await MainActor.run {
                        strongSelf.didUpdate?(strongSelf.creds)
                    }
                } catch (let error) {
                    print(error)
                }
            }
            
        }
    }
    
    func getCurrentServer() {
        guard let currentServerID = storageService.currentServerID else { return }
        
        Task {
            do {
                let creds = try await self.apiService.application.creds(id: currentServerID)
                self.creds = creds
                
                await MainActor.run {
                    self.didUpdate?(self.creds)
                }
            } catch (let error) {
                print(error)
            }
        }
    }
    
    private func getCheckSpeed() {
        self.speedService.checkForSpeedTest { [weak self] mb in
            self?.handleResult(mb: mb)
        }
    }
    
    private func handleResult(mb: Double?) {
        if var mb = mb {
            if mb <= 0 {
                mb = 0.5
            }
            let random = Double.random(in: 0...0.5)
            var upload = mb - random
            if upload <= 0 {
                upload = random
            }
            
            let downloadString = String(format: "%.2fmb", mb)
            let uploadString = String(format: "%.2fmb", upload)
            self.didCheckSpeed?(downloadString, uploadString)
        } else {
            let downloadString = "0.00mb"
            let uploadString = "0.00mb"
            self.didCheckSpeed?(downloadString, uploadString)
        }
    }
    
    private func vpnStateChanged(status: NEVPNStatus) {
        switch status {
            case .invalid:
                break
            case .disconnected, .reasserting:
                self.didChangeStatus?(.disconnect)
                self.getCheckSpeed()
            case .connected:
                self.didChangeStatus?(.connect)
                self.getCheckSpeed()
            case .connecting:
                self.didChangeStatus?(.connecting)
            case .disconnecting:
                self.didChangeStatus?(.disconnecting)
            @unknown default: break
        }
    }
    
    func loadConfig() {
        
    }
    
    func countryButtonTapped() {
        self.input.didSelectCountry?()
    }
    
    func settingsButtonTapped() {
        self.input.didSettingTap?()
    }
    
    func bannerButtonTapped() {
        self.input.didSpeedCheckerTap?()
    }
    
    func connectTapped() {
        if VPNManager.shared.isDisconnected {
            if self.storeService.hasUnlockedPro == false {
                self.input.didShowPaywall?()
                return
            }
            
            connect()
        } else {
            VPNManager.shared.disconnect()
        }
    }
    
    private func connect() {
        guard let server = self.creds else {
            self.didShowError?("Select server")
            return
        }
        
        let config = Configuration(server: server.id,
                                   account: server.username,
                                   password: server.password,
                                   onDemand: false,
                                   psk: nil)
        VPNManager.shared.connectIKEv2(config: config) { (success) in
//            self.tableView.reloadData()
        } onError: { (error) in
//            self.tableView.reloadData()
        }
    }
    
}
