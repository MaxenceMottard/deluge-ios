//
//  File.swift
//  Utils
//
//  Created by Maxence Mottard on 06/11/2024.
//

import Foundation

public enum StatusCode: Int, Sendable {
    case ok = 200
    case created = 201
    case accepted = 202
    case noContent = 204
    case badRequest = 400
    case unauthorized = 401
    case forbidden = 403
    case notFound = 404
    case tooManyRequests = 429
    case internalServerError = 500
    case serviceUnavailable = 503

    static let errorCodes = [
        StatusCode.badRequest,
        StatusCode.unauthorized,
        StatusCode.forbidden,
        StatusCode.notFound,
        StatusCode.tooManyRequests,
        StatusCode.internalServerError,
        StatusCode.serviceUnavailable,
    ]
    .map(\.rawValue)

    static let successCodes = [
        StatusCode.ok,
        StatusCode.created,
        StatusCode.accepted,
        StatusCode.noContent,
    ]
    .map(\.rawValue)
}
