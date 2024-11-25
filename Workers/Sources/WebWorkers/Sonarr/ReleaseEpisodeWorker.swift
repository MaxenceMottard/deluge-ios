//
//  ReleaseEpisodeWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 25/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol ReleaseEpisodeWorking: Sendable {
    func run(indexerId: Int, guid: String) async throws
}

struct ReleaseEpisodeWorker: ReleaseEpisodeWorking {
    struct Body: Encodable {
        let indexerId: Int
        let guid: String
    }

    func run(indexerId: Int, guid: String) async throws {
        let body = Body(indexerId: indexerId, guid: guid)

        return try await Request()
            .set(method: .POST)
            .set(path: "/api/v3/release")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(body: body)
            .run()
    }
}
