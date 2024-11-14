//
//  GetMoviesWebWorking.swift
//  Workers
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol GetMoviesWebWorking: Sendable {
    func run() async throws -> [Movie]
}

struct GetMoviesWebWorker: GetMoviesWebWorking {
    func run() async throws -> [Movie] {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/movie")
            .set(contentType: .json)
            .set(responseType: Void.self)
            .set(interceptor: InstanceInteceptor())
            .set(responseType: [GetMoviesWebWorkingResponse].self)
            .run()
            .toDomain()
    }
}
