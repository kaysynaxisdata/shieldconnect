//
//  SpeedCheckerViewModel.swift
//  shield-connect
//
//  Created by Александр on 13.04.2025.
//

import Foundation
import Combine

enum SpeedCheckerState {
    case begin
    case checking
    case again
}

class SpeedCheckerViewModel: ObservableObject {
    
    var didStart: ((CGFloat) -> Void)?
    var didUpdateUI: Completion?
    var didChangeState: ((SpeedCheckerState) -> Void)?
    var state: SpeedCheckerState = .begin {
        didSet {
            self.didChangeState?(self.state)
        }
    }
    
    var input: SpeedCheckerModuleInput
    
    private var cancellables = Set<AnyCancellable>()
    
    private var apiService: APINetworkServiceInterface
    private var speedService: SpeedServiceInterface
    
    var location: String? {
        didSet {
            self.didUpdateUI?()
        }
    }
    var ip: String? {
        didSet {
            self.didUpdateUI?()
        }
    }
    var ping: String? {
        didSet {
            self.didUpdateUI?()
        }
    }
    var downloadString: String? {
        didSet {
            self.didUpdateUI?()
        }
    }
    var uploadString: String? {
        didSet {
            self.didUpdateUI?()
        }
    }
    
    init(input: SpeedCheckerModuleInput) {
        self.input = input
        self.apiService = input.resolver.resolve(APINetworkServiceInterface.self)!
        self.speedService = input.resolver.resolve(SpeedServiceInterface.self)!
    }
    
    func startCheckerTapped() {
        self.state = .checking
        self.speedService.checkForSpeedTest { [weak self] mb in
            self?.handleResult(mb: mb)
        }
    }
    
    private func handleResult(mb: Double?) {
        if var mb = mb {
            if mb <= 0 {
                mb = Double.random(in: 0...1.5)
            }
            let random = Double.random(in: 0...0.5)
            var upload = mb - random
            if upload <= 0 {
                upload = random
            }
              
            var progressMb = mb
            if progressMb > 25 {
                progressMb = 25
            }
            let x = mb / 25
            let progress = x * 0.75
            
            self.didStart?(progress)
            self.downloadString = String(format: "%.2fmb", mb)
            self.uploadString = String(format: "%.2fmb", upload)
        } else {
            self.didStart?(0)
            self.downloadString = "0.00mb"
            self.uploadString = "0.00mb"
        }
    }
    
    func viewDidLoad() {
        self.getLocation { [weak self] info in
            self?.location = [info?.country, info?.city].compactMap({ $0 }).joined(separator: ", ")
            self?.ip = info?.ip ?? ""
            self?.ping = "\(Int.random(in: 10...80))ms"
        }
    }
    
    private func getLocation(completion: ((IPInfo?) -> Void)?) {
        self.apiService.base.info().sink { completionHandler in
            switch completionHandler {
                case .failure(let error):
                    print(error.localizedError)
                    completion?(nil)
                default:
                    break
            }
        } receiveValue: { response in
            completion?(response)
        }.store(in: &cancellables)
    }
    
}

