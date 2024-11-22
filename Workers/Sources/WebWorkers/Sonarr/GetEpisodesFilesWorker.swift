//
//  GetEpisodesFilesWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 22/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol GetEpisodesFilesWorking: Sendable {
    func run(serieId: Int) async throws -> [Serie.Episode.File]
}

struct GetEpisodesFilesWorker: GetEpisodesFilesWorking {
    func run(serieId: Int) async throws -> [Serie.Episode.File] {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/episodeFile")
            .set(queryParameter: "seriesId", value: "\(serieId)")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(responseType: [GetEpisodesFilesWorkerDecodable].self)
            .run()
            .toDomain()
    }
}
