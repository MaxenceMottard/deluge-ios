//
//  SearchSerieWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 26/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol SearchSerieWorking: Sendable {
    func run(search: String) async throws -> [SearchSerieResult]
}

struct SearchSerieWorker: SearchSerieWorking {
    func run(search: String) async throws -> [SearchSerieResult] {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/series/lookup")
            .set(queryParameter: "term", value: search)
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(responseType: [SearchSerieWorkerDecodable].self)
            .run()
            .toDomain()
    }
}
