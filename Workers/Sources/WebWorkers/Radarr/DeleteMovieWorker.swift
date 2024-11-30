//
//  DeleteMovieWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 29/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol DeleteMovieWorking: Sendable {
    func run(
        id: Int,
        deleteFiles: Bool,
        addImportListExclusion: Bool
    ) async throws
}

struct DeleteMovieWorker: DeleteMovieWorking {
    func run(
        id movieId: Int,
        deleteFiles: Bool,
        addImportListExclusion: Bool
    ) async throws {
        try await Request()
            .set(method: .DELETE)
            .set(path: "/api/v3/movie/\(movieId)")
            .set(contentType: .json)
            .set(queryParameter: "deleteFiles", value: "\(deleteFiles)")
            .set(queryParameter: "addImportListExclusion", value: "\(addImportListExclusion)")
            .set(interceptor: InstanceInteceptor())
            .run()
    }
}
