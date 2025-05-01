//
//  APIService.swift
//  TwoMatch
//
//  Created by Александр on 11.01.2024.
//

import Foundation

protocol APINetworkServiceInterface {
    var base: BaseNetworkServiceInterface { get set }
    var application: ApplicationNetworkServiceInterface { get set }
}

final class APINetworkService: APINetworkServiceInterface {
    var base: BaseNetworkServiceInterface = BaseNetworkService()
    var application: ApplicationNetworkServiceInterface = ApplicationNetworkService()
}
