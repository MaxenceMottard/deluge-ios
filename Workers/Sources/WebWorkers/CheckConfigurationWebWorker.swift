//
//  PingWebWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 08/11/2024.
//


import Networking

// sourcery: AutoMockable
public protocol CheckConfigurationWebWorking: Sendable {
    func run(instanceUrl url: String, apiKey: String) async throws
}

struct CheckConfigurationWebWorker: CheckConfigurationWebWorking {
    func run(instanceUrl url: String, apiKey: String) async throws {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/system/status")
            .set(contentType: .json)
            .set(responseType: Void.self)
            .set(url: url)
            .set(header: "x-api-key", value: apiKey)
            .run()
    }
}
