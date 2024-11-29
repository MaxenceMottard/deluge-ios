//
//  SearchSerieWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 26/11/2024.
//

import Foundation
import Networking

// sourcery: AutoMockable
public protocol SearchSerieWorking: Sendable {
    func run(search: String) async throws -> [SearchSerieResult]
}

struct SearchSerieWorker: SearchSerieWorking {
    func run(search: String) async throws -> [SearchSerieResult] {
        let data = try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/series/lookup")
            .set(queryParameter: "term", value: search)
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(responseType: Data.self)
            .run()

        let deserializedData = try JSONSerialization.jsonObject(with: data, options: []) as? [[String: any Sendable]]
        let decodedData = try JSONDecoder().decode([SearchSerieWorkerDecodable].self, from: data)

        return decodedData.indices.map {
            decodedData[$0].toDomain(data: deserializedData?[$0])
        }
    }
}
