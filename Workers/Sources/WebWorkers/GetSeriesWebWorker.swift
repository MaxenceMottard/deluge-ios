//
//  File.swift
//  Workers
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol GetSeriesWebWorking: Sendable {
    func run() async throws -> [Serie]
}

struct GetSeriesWebWorker: GetSeriesWebWorking {
    func run() async throws -> [Serie] {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/series")
            .set(contentType: .json)
            .set(responseType: Void.self)
            .set(interceptor: InstanceInteceptor())
            .set(responseType: [GetSeriesWebWorkingResponse].self)
            .run()
            .toDomain()
    }
}
