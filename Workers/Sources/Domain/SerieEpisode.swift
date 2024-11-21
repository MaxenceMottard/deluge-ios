//
//  SerieEpisode.swift
//  Workers
//
//  Created by Maxence Mottard on 21/11/2024.
//

import Foundation

public struct SerieEpisode: Sendable {
    public let id: Int
    public let title: String
    public let serieId: Int
    public let episodeFileId: Int
    public let seasonNumber: Int
    public let episodeNumber: Int
    public let hasFile: Bool
    public let monitored: Bool
    public let diffusionDate: Date?

    public init(
        id: Int,
        title: String,
        serieId: Int,
        episodeFileId: Int,
        seasonNumber: Int,
        episodeNumber: Int,
        hasFile: Bool,
        monitored: Bool,
        diffusionDate: Date?
    ) {
        self.id = id
        self.title = title
        self.serieId = serieId
        self.episodeFileId = episodeFileId
        self.seasonNumber = seasonNumber
        self.episodeNumber = episodeNumber
        self.hasFile = hasFile
        self.monitored = monitored
        self.diffusionDate = diffusionDate
    }
}

extension GetSerieEpisodeWebWorkerResponse {
    func toDomain() -> SerieEpisode {
        let formatter = ISO8601DateFormatter()

        let diffusionDate: Date? = if let airDateUtc {
            formatter.date(from: airDateUtc)
        } else {
            nil
        }

        return SerieEpisode(
            id: id,
            title: title,
            serieId: seriesId,
            episodeFileId: episodeFileId,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            hasFile: hasFile,
            monitored: monitored,
            diffusionDate: diffusionDate
        )
    }
}

extension Array where Element == GetSerieEpisodeWebWorkerResponse {
    func toDomain() -> [SerieEpisode] { map { $0.toDomain() } }
}
