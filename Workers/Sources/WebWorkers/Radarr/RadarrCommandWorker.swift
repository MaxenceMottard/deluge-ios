//
//  RadarrCommandWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 23/11/2024.
//

import Foundation
import Networking

public enum RadarrCommand: Sendable {
    case refreshMovie(id: Int)
}

// sourcery: AutoMockable
public protocol RadarrCommandWorking: Sendable {
    func run(command: RadarrCommand) async throws
}

struct RadarrCommandWorker: RadarrCommandWorking {
    func run(command: RadarrCommand) async throws {
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

extension RadarrCommand {
    var body: [String: Any] {
        switch self {
        case let .refreshMovie(id):
            [
                "name": "RefreshMovie",
                "episodeIds": [id],
            ]
        }
    }
}
