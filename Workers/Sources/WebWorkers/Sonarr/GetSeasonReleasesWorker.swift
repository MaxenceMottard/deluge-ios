//
//  GetSeasonReleasesWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 23/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol GetSeasonReleasesWorking: Sendable {
    func run(serieId: Int, seasonNumber: Int) async throws -> [Release]
}

struct GetSeasonReleasesWorker: GetSeasonReleasesWorking {
    func run(serieId: Int, seasonNumber: Int) async throws -> [Release] {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/release")
            .set(contentType: .json)
            .set(queryParameter: "seriesId", value: "\(serieId)")
            .set(queryParameter: "seasonNumber", value: "\(seasonNumber)")
            .set(interceptor: InstanceInteceptor())
            .set(responseType: [GetEpisodeReleasesWorkerDecodable].self)
            .run()
            .toDomain()
    }
}
