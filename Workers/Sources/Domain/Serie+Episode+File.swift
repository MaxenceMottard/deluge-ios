//
//  File.swift
//  Workers
//
//  Created by Maxence Mottard on 22/11/2024.
//

import Foundation

extension Serie.Episode {
    public struct File: Sendable {
        public let id: Int
        public let serieId: Int
        public let seasonNumber: Int
        public let relativePath: String
        public let path: String
        public let size: Int
        public let dateAdded: Date?
        public let quality: Quality

        public init(
            id: Int,
            serieId: Int,
            seasonNumber: Int,
            relativePath: String,
            path: String,
            size: Int,
            dateAdded: Date?,
            quality: Quality
        ) {
            self.id = id
            self.serieId = serieId
            self.seasonNumber = seasonNumber
            self.relativePath = relativePath
            self.path = path
            self.size = size
            self.dateAdded = dateAdded
            self.quality = quality
        }

        public struct Quality: Sendable {
            public let id: Int
            public let name: String
            public let source: String
            public let resolution: Int

            public init(id: Int, name: String, source: String, resolution: Int) {
                self.id = id
                self.name = name
                self.source = source
                self.resolution = resolution
            }
        }
    }
}

extension GetEpisodesFilesWorkerDecodable {
    func toDomain() -> Serie.Episode.File {
        let formatter = ISO8601DateFormatter()

        return Serie.Episode.File(
            id: id,
            serieId: seriesId,
            seasonNumber: seasonNumber,
            relativePath: relativePath,
            path: path,
            size: size,
            dateAdded: formatter.date(from: dateAdded),
            quality: Serie.Episode.File.Quality(
                id: quality.quality.id,
                name: quality.quality.name,
                source: quality.quality.source,
                resolution: quality.quality.resolution
            )
        )
    }
}

extension [GetEpisodesFilesWorkerDecodable] {
    func toDomain() -> [Serie.Episode.File] {
        return map { $0.toDomain() }
    }
}
