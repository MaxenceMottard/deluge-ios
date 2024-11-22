//
//  GetEpisodesWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol GetEpisodesWorking: Sendable {
    func run(id: Int) async throws -> [Serie.Episode]
}

struct GetEpisodesWorker: GetEpisodesWorking {
    func run(id serieId: Int) async throws -> [Serie.Episode] {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/episode")
            .set(queryParameter: "seriesId", value: "\(serieId)")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(responseType: [GetEpisodesWorkerDecodable].self)
            .run()
            .toDomain()
    }
}
