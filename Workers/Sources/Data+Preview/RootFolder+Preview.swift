//
//  RootFolder+Preview.swift
//  Workers
//
//  Created by Maxence Mottard on 29/11/2024.
//

import Foundation

public extension RootFolder {
    static func preview(
        id: Int = UUID().hashValue,
        path: String = "/path/to/root",
        accessible: Bool = true,
        freeSpace: Int = 10031312462
    ) -> RootFolder {
        RootFolder(
            id: id,
            path: path,
            accessible: accessible,
            freeSpace: freeSpace
        )
    }
}

public extension [RootFolder] {
    static var preview: [RootFolder] {
        [
            .preview(path: "/root/path/1"),
            .preview(path: "/root/path/2"),
            .preview(path: "/root/path/3"),
            .preview(path: "/root/path/4"),
        ]
    }
}
