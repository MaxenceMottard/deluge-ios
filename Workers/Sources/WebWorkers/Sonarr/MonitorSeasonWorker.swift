//
//  MonitorSeasonWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 22/11/2024.
//

import Foundation
import Networking

// sourcery: AutoMockable
public protocol MonitorSeasonWorking: Sendable {
    func run(serieId: Int, seasonNumber: Int, monitored: Bool) async throws
}

struct MonitorSeasonWorker: MonitorSeasonWorking {
    func run(serieId: Int, seasonNumber: Int, monitored: Bool) async throws {
        let resultData = try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/series/\(serieId)")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(responseType: Data.self)
            .run()

        guard var serie = try JSONSerialization.jsonObject(with: resultData, options: []) as? [String: Any],
            let seasons = serie["seasons"] as? [[String: Any]] else {
            throw RequestError.invalidData
        }

        serie["seasons"] = seasons.map { season in
            guard let seasonNum = season["seasonNumber"] as? Int, seasonNum == seasonNumber else { return season }
            var updatedSeason = season
            updatedSeason["monitored"] = monitored
            return updatedSeason
        }

        let data = try JSONSerialization.data(withJSONObject: serie)

        return try await Request()
            .set(method: .PUT)
            .set(path: "/api/v3/series/\(serieId)")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(body: data)
            .run()
    }
}
