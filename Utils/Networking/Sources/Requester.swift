//
//  Requester.swift
//  Utils
//
//  Created by Maxence Mottard on 06/11/2024.
//

import Foundation

// sourcery: AutoMockable
protocol Requester {
    func data(for request: URLRequest) async throws(RequestError) -> (Data, URLResponse)
}

extension URLSession: Requester {
    func data(for request: URLRequest) async throws(RequestError) -> (Data, URLResponse) {
        do {
            return try await data(for: request)
        } catch {
            throw RequestError.unknow(error)
        }
    }
}
