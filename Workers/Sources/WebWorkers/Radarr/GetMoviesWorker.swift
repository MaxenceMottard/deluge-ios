//
//  GetMoviesWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol GetMoviesbWorking: Sendable {
    func run() async throws -> [Movie]
}

struct GetMoviesWorker: GetMoviesbWorking {
    func run() async throws -> [Movie] {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/movie")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(responseType: [GetMoviesWorkerDecodable].self)
            .run()
            .toDomain()
    }
}
