//
//  Requester.swift
//  Utils
//
//  Created by Maxence Mottard on 06/11/2024.
//

import Foundation

// sourcery: AutoMockable
protocol Requester {
    func data(for request: URLRequest) async throws -> (Data, URLResponse)
}

extension URLSession: Requester {}
