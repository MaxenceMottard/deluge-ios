//
//  RootFolder.swift
//  Workers
//
//  Created by Maxence Mottard on 26/11/2024.
//

import Foundation

public struct RootFolder: Sendable, Identifiable, Hashable {
    public let id: Int
    public let path: String
    public let accessible: Bool
    public let freeSpace: Int

    public init(id: Int, path: String, accessible: Bool, freeSpace: Int) {
        self.id = id
        self.path = path
        self.accessible = accessible
        self.freeSpace = freeSpace
    }
}

extension GetRootFoldersWorkerDecodable {
    func toDomain() -> RootFolder {
        return RootFolder(
            id: id,
            path: path,
            accessible: accessible,
            freeSpace: freeSpace
        )
    }
}

extension [GetRootFoldersWorkerDecodable] {
    func toDomain() -> [RootFolder] {
        return self.map { $0.toDomain() }
    }
}
