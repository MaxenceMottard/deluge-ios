//
//  SystemStatusWebWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 08/11/2024.
//


import Networking

// sourcery: AutoMockable
public protocol SystemStatusWebWorking: Sendable {
    func run(instanceUrl url: String, apiKey: String) async throws -> SystemStatus
}

struct SystemStatusWebWorker: SystemStatusWebWorking {
    func run(instanceUrl url: String, apiKey: String) async throws -> SystemStatus {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/system/status")
            .set(contentType: .json)
            .set(url: url)
            .set(header: "x-api-key", value: apiKey)
            .set(responseType: SystemStatusWebWorkerResponse.self)
            .run()
            .toDomain()
    }
}
