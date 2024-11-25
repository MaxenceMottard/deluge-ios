//
//  Serie+Episode+File+Preview.swift
//  Screens
//
//  Created by Maxence Mottard on 10/11/2024.
//

import Foundation
import Utils

public extension Serie.Episode.File {
    static func preview(
        serieId: Int = UUID().hashValue,
        seasonNumber: Int = 1,
        relativePath: String = "/path/to/file.mkv",
        path: String = "/path/to/file.mkv",
        size: Int = 31312462,
        dateAdded: Date? = Date(),
        quality: Quality = Quality(
            id: UUID().hashValue,
            name: "WEBDL-1080p",
            source: "WEBDL",
            resolution: 1080
        )
    ) -> Serie.Episode.File {
        return Serie.Episode.File(
            id: UUID().hashValue,
            serieId: serieId,
            seasonNumber: seasonNumber,
            relativePath: relativePath,
            path: path,
            size: size,
            dateAdded: dateAdded,
            quality: quality
        )
    }
}
