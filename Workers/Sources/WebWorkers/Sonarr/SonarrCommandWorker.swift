//
//  SonarrCommandWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 23/11/2024.
//

import Foundation
import Networking

public enum SonarrCommand: Sendable {
    case episodeSearch(ids: [Int])
    case seasonSearch(serieId: Int, seasonNumber: Int)
}

// sourcery: AutoMockable
public protocol SonarrCommandWorking: Sendable {
    func run(command: SonarrCommand) async throws
}

struct SonarrCommandWorker: SonarrCommandWorking {
    func run(command: SonarrCommand) async throws {
        let data = try? JSONSerialization.data(withJSONObject: command.body, options: [])

        return try await Request()
            .set(method: .POST)
            .set(path: "/api/v3/command")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(body: data)
            .run()
    }
}

extension SonarrCommand {
    var body: [String: Any] {
        switch self {
        case let .episodeSearch(ids):
            [
                "name": "EpisodeSearch",
                "episodeIds": ids,
            ]
        case let .seasonSearch(serieId, seasonNumber):
            [
                "name": "SeasonSearch",
                "seriesId": serieId,
                "seasonNumber": seasonNumber,
            ]
        }
    }
}
