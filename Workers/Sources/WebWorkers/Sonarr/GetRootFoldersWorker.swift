//
//  GetRootFoldersWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 26/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol GetRootFoldersWorking: Sendable {
    func run() async throws -> [RootFolder]
}

struct GetRootFoldersWorker: GetRootFoldersWorking {
    func run() async throws -> [RootFolder] {
        try await Request()
            .set(method: .GET)
            .set(path: "/api/v3/rootFolder")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(responseType: [GetRootFoldersWorkerDecodable].self)
            .run()
            .toDomain()
    }
}
