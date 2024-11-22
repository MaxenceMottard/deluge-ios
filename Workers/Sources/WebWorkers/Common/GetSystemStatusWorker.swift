//
//  GetSystemStatusWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 08/11/2024.
//


import Networking

// sourcery: AutoMockable
public protocol GetSystemStatusWorking: Sendable {
    func run(instanceUrl url: String, apiKey: String) async throws -> SystemStatus
}

struct GetSystemStatusWorker: GetSystemStatusWorking {
    func run(instanceUrl url: String, apiKey: String) async throws -> SystemStatus {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/system/status")
            .set(contentType: .json)
            .set(url: url)
            .set(header: "x-api-key", value: apiKey)
            .set(responseType: GetSystemStatusWorkerDecodable.self)
            .run()
            .toDomain()
    }
}
