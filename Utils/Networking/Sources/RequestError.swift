//
//  RequestError.swift
//  Utils
//
//  Created by Maxence Mottard on 06/11/2024.
//

import Foundation

public enum RequestError: Error, Equatable {
    case http(StatusCode)
    case httpUnknown(Int)
    case unknown
    case wrongResponseType(Any.Type)
    case noURL
    case noMethod
    case invalidURL

    public static func == (lhs: RequestError, rhs: RequestError) -> Bool {
        switch (lhs, rhs) {
        case let (.http(lhsStatusCode), .http(rhsStatusCode)):
            return lhsStatusCode == rhsStatusCode
        case let (.httpUnknown(lhsCode), .httpUnknown(rhsCode)):
            return lhsCode == rhsCode
        case let (.wrongResponseType(lhsType), .wrongResponseType(rhsType)):
            return lhsType == rhsType
        case (.noURL, .noURL), (.noMethod, .noMethod), (.invalidURL, .invalidURL), (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
