//
//  ErrorResponse.swift
//  odola-app
//
//  Created by Александр on 14.09.2024.
//

import Foundation

struct ErrorResponse: Codable, Error {
    var status: Int?
    var error: String?
    var details: String?
    
    var localizedError: String {
        return self.error ?? "L10n.Error.serverError"
    }
    var messages: [String] = []
    
    enum CodingKeys: String, CodingKey {
      case status
      case message
      case error
    }
    
    init(status: Int, message: String) {
        self.status = status
        self.messages = [message]
        self.details = message
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(status, forKey: .status)
        try container.encode(error, forKey: .error)
      }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        status = try? container.decode(Int.self, forKey: .status)

        if let messages = try? container.decode([String].self, forKey: .message) {
            self.messages = messages
        }
        if let message = try? container.decode(String.self, forKey: .message) {
            self.messages = [message]
        }
        error = try? container.decode(String.self, forKey: .error)
        details = ""
    }
    
    static var unknownError: ErrorResponse {
        return ErrorResponse(status: 0, message: "L10n.Error.serverError")
    }
    static var tooManyRequestError: ErrorResponse {
        return ErrorResponse(status: 429, message: "tooManyRequest")
    }
    static var unauthorized: ErrorResponse {
        return ErrorResponse(status: 401, message: "Please authorize")
    }
    static var cannotGetResponseData: ErrorResponse {
        return ErrorResponse(status: 0, message: "cannotGetResponseData")
    }
    static var cannotResponseDecode: ErrorResponse {
        return ErrorResponse(status: 998, message: "Cannot response decode")
    }
    static func custom(string: String) -> ErrorResponse {
        return ErrorResponse(status: 0, message: string)
    }
}
