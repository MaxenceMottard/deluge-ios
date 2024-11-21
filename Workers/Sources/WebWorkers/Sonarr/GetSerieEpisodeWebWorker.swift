//
//  GetSerieEpisodeWebWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol GetSerieEpisodeWebWorking: Sendable {
    func run(id: Int) async throws -> [SerieEpisode]
}

struct GetSerieEpisodeWebWorker: GetSerieEpisodeWebWorking {
    func run(id serieId: Int) async throws -> [SerieEpisode] {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/episode")
            .set(queryParameter: "seriesId", value: "\(serieId)")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(responseType: [GetSerieEpisodeWebWorkerResponse].self)
            .run()
            .toDomain()
    }
}
