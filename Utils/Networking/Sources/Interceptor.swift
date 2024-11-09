//
//  Interceptor.swift
//  Utils
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Foundation

public protocol Interceptor {
    func intercept<Response: Sendable>(request: RequestBuilder<Response>) throws -> RequestBuilder<Response>
}
