//
//  Serie+Episode.swift
//  Workers
//
//  Created by Maxence Mottard on 21/11/2024.
//

import Foundation

extension Serie {
    public struct Episode: Sendable {
        public let id: Int
        public let title: String
        public let serieId: Int
        public let fileId: Int
        public let seasonNumber: Int
        public let episodeNumber: Int
        public let isDownloaded: Bool
        public let isMonitored: Bool
        public let diffusionDate: Date?

        public init(
            id: Int,
            title: String,
            serieId: Int,
            fileId: Int,
            seasonNumber: Int,
            episodeNumber: Int,
            isDownloaded: Bool,
            isMonitored: Bool,
            diffusionDate: Date?
        ) {
            self.id = id
            self.title = title
            self.serieId = serieId
            self.fileId = fileId
            self.seasonNumber = seasonNumber
            self.episodeNumber = episodeNumber
            self.isDownloaded = isDownloaded
            self.isMonitored = isMonitored
            self.diffusionDate = diffusionDate
        }
    }
}

extension GetEpisodesWorkerDecodable {
    func toDomain() -> Serie.Episode {
        let formatter = ISO8601DateFormatter()

        let diffusionDate: Date? = if let airDateUtc {
            formatter.date(from: airDateUtc)
        } else {
            nil
        }

        return Serie.Episode(
            id: id,
            title: title,
            serieId: seriesId,
            fileId: episodeFileId,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            isDownloaded: hasFile,
            isMonitored: monitored,
            diffusionDate: diffusionDate
        )
    }
}

extension Array where Element == GetEpisodesWorkerDecodable {
    func toDomain() -> [Serie.Episode] { map { $0.toDomain() } }
}
