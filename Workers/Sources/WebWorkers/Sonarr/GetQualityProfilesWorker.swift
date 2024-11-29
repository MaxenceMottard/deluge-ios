//
//  GetQualityProfilesWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 26/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol GetQualityProfilesWorking: Sendable {
    func run() async throws -> [QualityProfile]
}

struct GetQualityProfilesWorker: GetQualityProfilesWorking {
    func run() async throws -> [QualityProfile] {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/qualityprofile")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(responseType: [GetQualityProfilesWorkerDecodable].self)
            .run()
            .toDomain()
    }
}
