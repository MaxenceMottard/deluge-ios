//
//  ReleaseEpisodeWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 23/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol ReleaseEpisodeWorking: Sendable {
    func run(id episodeId: Int) async throws -> [ReleaseResult]
}

struct ReleaseEpisodeWorker: ReleaseEpisodeWorking {
    func run(id episodeId: Int) async throws -> [ReleaseResult] {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/release")
            .set(contentType: .json)
            .set(queryParameter: "episodeId", value: "\(episodeId)")
            .set(interceptor: InstanceInteceptor())
            .set(responseType: [ReleaseEpisodeWorkerDecodable].self)
            .run()
            .toDomain()
    }
}
