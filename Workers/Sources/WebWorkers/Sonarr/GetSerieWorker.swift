//
//  GetSerieWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 22/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol GetSerieWorking: Sendable {
    func run(id: Int) async throws -> Serie
}

struct GetSerieWorker: GetSerieWorking {
    func run(id: Int) async throws -> Serie {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/series/\(id)")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(responseType: GetSeriesWorkerDecodable.self)
            .run()
            .toDomain()
    }
}
