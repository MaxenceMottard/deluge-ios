//
//  ReleaseEpisodeWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 23/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol GetEpisodeReleasesWorking: Sendable {
    func run(id episodeId: Int) async throws -> [Release]
}

struct GetEpisodeReleasesWorker: GetEpisodeReleasesWorking {
    func run(id episodeId: Int) async throws -> [Release] {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/release")
            .set(contentType: .json)
            .set(queryParameter: "episodeId", value: "\(episodeId)")
            .set(interceptor: InstanceInteceptor())
            .set(responseType: [GetReleasesWorkerDecodable].self)
            .run()
            .toDomain()
    }
}
