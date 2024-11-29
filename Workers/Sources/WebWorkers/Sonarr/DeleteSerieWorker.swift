//
//  DeleteSerieWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 29/11/2024.
//

import Networking

// sourcery: AutoMockable
public protocol DeleteSerieWorking: Sendable {
    func run(
        id: Int,
        deleteFiles: Bool,
        addImportListExclusion: Bool
    ) async throws
}

struct DeleteSerieWorker: DeleteSerieWorking {
    func run(
        id serieId: Int,
        deleteFiles: Bool,
        addImportListExclusion: Bool
    ) async throws {
        try await Request()
            .set(method: .DELETE)
            .set(path: "/api/v3/series/\(serieId)")
            .set(queryParameter: "deleteFiles", value: "\(deleteFiles)")
            .set(queryParameter: "addImportListExclusion", value: "\(addImportListExclusion)")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .run()
    }
}
