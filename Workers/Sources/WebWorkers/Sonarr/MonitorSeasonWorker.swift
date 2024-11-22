//
//  MonitorSeasonWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 22/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol MonitorSeasonWorking: Sendable {
    func run(serieId: Int, seasonNumber: Int, monitored: Bool) async throws
}

struct MonitorSeasonWorker: MonitorSeasonWorking {
    func run(serieId: Int, seasonNumber: Int, monitored: Bool) async throws {
        var serie = try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/series/\(serieId)")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(responseType: MonitorSeasonWorkerCodable.self)
            .run()

        serie.seasons = serie.seasons.map { season in
            guard season.seasonNumber == seasonNumber else { return season }
            var season = season
            season.monitored = monitored
            return season
        }

        return try await Request()
            .set(method: .PUT)
            .set(path: "/api/v3/series/\(serieId)")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(body: serie)
            .run()
    }
}
