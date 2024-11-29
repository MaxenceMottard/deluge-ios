//
//  RequestError.swift
//  Utils
//
//  Created by Maxence Mottard on 06/11/2024.
//

import Foundation

public enum RequestError: Error, Equatable {
    case http(StatusCode, String?)
    case httpUnknown(Int, String?)
    case unknown
    case wrongResponseType(Any.Type)
    case noURL
    case noMethod
    case invalidURL
    case invalidData

    public static func == (lhs: RequestError, rhs: RequestError) -> Bool {
        switch (lhs, rhs) {
        case let (.http(lhsStatusCode, lhsString), .http(rhsStatusCode, rhsString)):
            return lhsStatusCode == rhsStatusCode && lhsString == rhsString
        case let (.httpUnknown(lhsCode, lhsString), .httpUnknown(rhsCode, rhsString)):
            return lhsCode == rhsCode && lhsString == rhsString
        case let (.wrongResponseType(lhsType), .wrongResponseType(rhsType)):
            return lhsType == rhsType
        case (.noURL, .noURL), (.noMethod, .noMethod), (.invalidURL, .invalidURL), (.unknown, .unknown):
            return true
        default:
            return false
        }
    }
}
