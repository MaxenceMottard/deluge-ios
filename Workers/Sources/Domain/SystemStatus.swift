//
//  SystemStatusWebWorking.swift
//  Workers
//
//  Created by Maxence Mottard on 10/11/2024.
//

import Foundation

public struct SystemStatus: Sendable {
    public let version: String

    public init(version: String) {
        self.version = version
    }
}

extension GetSystemStatusWorkerDecodable {
    func toDomain() -> SystemStatus {
        return SystemStatus(version: version)
    }
}
