//
//  GetSerieQueueWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 25/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol GetSerieQueueWorking: Sendable {
    func run(id: Int) async throws -> [Serie.QueueItem]
}

struct GetSerieQueueWorker: GetSerieQueueWorking {
    func run(id serieId: Int) async throws -> [Serie.QueueItem] {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/queue/details")
            .set(contentType: .json)
            .set(queryParameter: "seriesId", value: "\(serieId)")
            .set(interceptor: InstanceInteceptor())
            .set(responseType: [GetSerieQueueWorkerDecodable].self)
            .run()
            .toDomain()
    }
}
