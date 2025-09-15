//
//  Constants.swift
//  shield-connect
//
//  Created by Александр on 01.04.2025.
//

import Foundation

typealias Completion = () -> Void

struct Constants {
    
    enum HttpHeaderField: String {
        case authentication = "Authorization"
        case contentType = "Content-Type"
        case acceptType = "Accept"
        case acceptEncoding = "Accept-Encoding"
        case acceptLanguage = "accept-language"
    }
    
    enum ContentType: String {
        case json = "application/json"
    }
    
    struct Subscriptions {
        static let week = "com.shieldvpn.shieldconnect.week"
        static let month = "com.shieldvpn.shieldconnect.month"
        static let year = "com.shieldvpn.shieldconnect.year"
        static let productIds = [Self.week, Self.month]
    }
    
    struct URLs {
        static let privacy: String = "https://doc-hosting.flycricket.io/shield-connect-secure-vpn-privacy-policy/12bb1bf5-f3df-45e7-b7be-52595c9c81e5/privacy"
        static let terms: String = "https://doc-hosting.flycricket.io/shield-connect-secure-vpn-terms-of-use/03ad9e1b-db1f-44da-99ad-b17d385d069d/terms"
        static let support: String = "kay@synaxisdata.space"
    }
    
}
