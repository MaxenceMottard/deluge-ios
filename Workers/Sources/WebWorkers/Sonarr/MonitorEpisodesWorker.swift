//
//  MonitorEpisodesWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol MonitorEpisodesWorking: Sendable {
    func run(ids: [Int], monitored: Bool) async throws -> Void
}

struct MonitorEpisodesWorker: MonitorEpisodesWorking {
    struct Body: Encodable {
        let episodeIds: [Int]
        let monitored: Bool
    }

    func run(ids episodeIds: [Int], monitored: Bool) async throws -> Void {
        let body = Body(episodeIds: episodeIds, monitored: monitored)

        return try await Request()
            .set(method: .PUT)
            .set(path: "/api/v3/episode/monitor")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(body: body)
            .run()
    }
}
