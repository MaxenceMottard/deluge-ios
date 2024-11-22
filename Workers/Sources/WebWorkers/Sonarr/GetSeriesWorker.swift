//
//  GetSeriesWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol GetSeriesWorking: Sendable {
    func run() async throws -> [Serie]
}

struct GetSeriesWorker: GetSeriesWorking {
    func run() async throws -> [Serie] {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/series")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(responseType: [GetSeriesWorkerDecodable].self)
            .run()
            .toDomain()
    }
}
