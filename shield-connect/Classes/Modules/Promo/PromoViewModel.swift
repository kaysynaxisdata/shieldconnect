//
//  PromoViewModel.swift
//  shield-connect
//
//  Created by Александр on 22.08.2025.
//

import Foundation

struct PromoStep: Decodable {
    let subStep1: String
    let subStep2: String

    enum CodingKeys: String, CodingKey {
        case subStep1 = "sub_step_1"
        case subStep2 = "sub_step_2"
    }
}

struct PromoResponse: Decodable {
    var productId: String
    var promo_struct: PromoStruct?
    var lines: [SecurityCheckLine]?
    var callToAction: String
    var df: String?
}

struct SecurityCheckLine: Codable {
    var title: String
    var subtitle: String
    var icon: String
    var steps: [String]?
    var stepName: String
    var checkIcon: String
    var processIcon: String
    var isPayment: Bool
    var delay: Int?
    
    enum CodingKeys: String, CodingKey {
        case title, subtitle, icon, steps, stepName, checkIcon, processIcon, isPayment, delay
    }
    
}

extension PromoResponse {
    static let mock: [SecurityCheckLine] = .init(
        [
            SecurityCheckLine(
                title: "Rapid check\nthe security of iCloud\nand Apple ID",
                subtitle: "Your security and comfort are our top priorities",
                icon: "www.google.com",
                steps: [
                    "Verifying the activation of login notifications for new devices…",
                    "Verifying the activation of two-factor authentication…",
                    "Notification confirming entry through another device…"
                ],
                stepName: "Login Notifications",
                checkIcon: "URLString",
                processIcon: "URLString",
                isPayment: false,
                delay: 6000
            ),
            SecurityCheckLine(
                title: "Rapid check\nthe security of iCloud\nand Apple ID",
                subtitle: "Your security and comfort are our top priorities",
                icon: "www.google.com",
                steps: [
                    "Verifying the presence of passwords on devices…",
                    "Verifying the activation of lock/remote control features…",
                    "Checking the phishing software on device…"
                ],
                stepName: "Device Passwords",
                checkIcon: "URLString",
                processIcon: "URLString",
                isPayment: false,
                delay: 6000
            ),
            SecurityCheckLine(
                title: "Rapid check\nthe security of iCloud\nand Apple ID",
                subtitle: "Your security and comfort are our top priorities",
                icon: "www.google.com",
                steps: [
                    "Verifying the activation of data backup in iCloud…",
                    "Checking and removing unnecessary devices…",
                    "Alerting against the use of open and unreliable Wi-Fi networks…"
                ],
                stepName: "Data Backup",
                checkIcon: "URLString",
                processIcon: "URLString",
                isPayment: false,
                delay: 6000
            ),
            SecurityCheckLine(
                title: "All identified\nchallenges have been effectively neutralized",
                subtitle: "Your security is currently operating at peak levels. ",
                icon: "www.google.com",
                steps: nil,
                stepName: "Keep the app on your phone.\nDeleting it might expose\nyour device and data",
                checkIcon: "URLString",
                processIcon: "URLString",
                isPayment: true
            )
        ]
    )
}

struct PromoStruct: Decodable {
    let title: String
    let subtitle: String
    let bottomText: String
    let steps: [String: PromoStep]  // "step_1", "step_2", ...

    enum CodingKeys: String, CodingKey {
        case title
        case subtitle
        case bottomText = "bottom_text"
        case steps
    }

//    /// Шаги, отсортированные по числу в ключе ("step_10" > "step_2").
//    var orderedSteps: [(key: String, step: PromoStep)] {
//        steps.sorted { lhs, rhs in
//            Self.stepIndex(lhs.key) < Self.stepIndex(rhs.key)
//        }
//    }
//
//    private static func stepIndex(_ key: String) -> Int {
//        // вытаскиваем все цифры из "step_12" -> 12
//        let digits = key.filter(\.isNumber)
//        return Int(digits) ?? Int.max
//    }
}

protocol PromoViewModel {
    var promo: PromoResponse { get set }
    var didLoading: ((Bool) -> Void)? { get set }
    var didShowError: ((String) -> Void)? { get set }
    
    func viewDidLoad()
    func actionButtonTapped()
}

class PromoViewModelImplementation: PromoViewModel {
    
    var didLoading: ((Bool) -> Void)?
    var didShowError: ((String) -> Void)?
    
    var input: PromoModuleInput
    var storeService: StoreService
    var networkService: APINetworkService
    var storageService: StorageService
    var promo: PromoResponse
    
    init(input: PromoModuleInput) {
        self.input = input
        self.storeService = input.resolver.resolve(StoreService.self)!
        self.networkService = input.resolver.resolve(APINetworkService.self)!
        self.storageService = input.resolver.resolve(StorageService.self)!
        self.promo = input.promo
    }
    
    func payTapped() {
        self.didLoading?(true)
        self.storeService.pay(
            productId: self.promo.productId,
            completion: { [weak self] errorString in
                
                guard let self = self else { return }
                
                DispatchQueue.main.async {
                    self.didLoading?(false)
                    if let errorString = errorString {
                        self.didShowError?(errorString)
                    } else {
                        Task {
                            do {
                                let paywall = self.promo.df ?? "unknown"
                                let _ = try await self.networkService.application.notify(
                                    acc: self.storageService.accToken,
                                    paywall: paywall
                                )
                            }
                        }
                    }
                }
            }
        )
    }
    
}


extension PromoViewModelImplementation {
    
    func viewDidLoad() {
        self.storeService.didUpdate = { [weak self] in
            if self?.storeService.hasUnlockedPro == true {
                self?.input.didFinish?()
            }
        }
    }
    
    func actionButtonTapped() {
        self.payTapped()
    }
    
}
