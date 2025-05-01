//
//  Country.swift
//  bear-vpn
//
//  Created by Александр on 22.12.2024.
//

import Foundation

class ServerCountry: Codable {
    var id: String
    var country: String
    var flag: String
}

class Country: Codable {
    var id: String
    var username: String
    var password: String
    var country: String
    var flag: String
}
