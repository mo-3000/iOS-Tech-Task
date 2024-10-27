//
//  ErrorResponse.swift
//  MoneyBox
//
//  Created by Zeynep Kara on 16.01.2022.
//

import Foundation

public enum LoginError {
    case unknown
    case email
    case password
}

// MARK: - ErrorResponse
public struct ErrorResponse: Codable, Error {
    public let name: String?
    public let message: String?
    public let validationErrors: [ValidationError]?

    enum CodingKeys: String, CodingKey {
        case name = "Name"
        case message = "Message"
        case validationErrors = "ValidationErrors"
    }
    
    public struct ValidationError: Codable {
        public let name: String?
        public let message: String?

        enum CodingKeys: String, CodingKey {
            case name = "Name"
            case message = "Message"
        }
    }
    
    public var email: String {
        return validationErrors?.first(where: { $0.name == "Email"})?.message ?? ""
    }
    
    public var password: String {
        return validationErrors?.first(where: { $0.name == "Password"})?.message ?? ""
    }
    
    public var loginError: LoginError {
        guard let validationErrors = validationErrors else {
            return .unknown
        }
        
        for error in validationErrors {
            switch error.name {
            case "Email":
                return .email
            case "Password":
                return .password
            case "Login failed":
                return .unknown
            default:
                break
            }
        }
        
        return .unknown
    }
}
