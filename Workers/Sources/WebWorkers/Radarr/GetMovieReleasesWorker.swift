//
//  GetMovieReleasesWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 29/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol GetMovieReleasesWorking: Sendable {
    func run(id: Int) async throws -> [Release]
}

struct GetMovieReleasesWorker: GetMovieReleasesWorking {
    func run(id movieId: Int) async throws -> [Release] {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/release")
            .set(queryParameter: "movieId", value: "\(movieId)")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(responseType: [GetReleasesWorkerDecodable].self)
            .run()
            .toDomain()
    }
}
