//
//  ReleaseResult.swift
//  Workers
//
//  Created by Maxence Mottard on 24/11/2024.
//

import Foundation

public struct ReleaseResult: Sendable, Equatable {
    public let title: String
    public let infoUrl: String
    public let downloadUrl: String
    public let rejected: Bool
    public let approved: Bool
    public let publishDate: Date?
    public let seeders: Int
    public let leechers: Int
    public let quality: Quality
    public let size: Int
    public let ageHours: Double
    public let ageMinutes: Double
    public let indexer: String

    public init(
        title: String,
        infoUrl: String,
        downloadUrl: String,
        rejected: Bool,
        approved: Bool,
        publishDate: Date?,
        seeders: Int,
        leechers: Int,
        quality: Quality,
        size: Int,
        ageHours: Double,
        ageMinutes: Double,
        indexer: String
    ) {
        self.title = title
        self.infoUrl = infoUrl
        self.downloadUrl = downloadUrl
        self.rejected = rejected
        self.approved = approved
        self.publishDate = publishDate
        self.seeders = seeders
        self.leechers = leechers
        self.quality = quality
        self.size = size
        self.ageHours = ageHours
        self.ageMinutes = ageMinutes
        self.indexer = indexer
    }
}

extension ReleaseEpisodeWorkerDecodable {
    func toDomain() -> ReleaseResult {
        let formatter = ISO8601DateFormatter()

        return ReleaseResult(
            title: title,
            infoUrl: infoUrl,
            downloadUrl: downloadUrl,
            rejected: rejected,
            approved: approved,
            publishDate: formatter.date(from: publishDate),
            seeders: seeders,
            leechers: leechers,
            quality: Workers.Quality(
                id: quality.quality.id,
                name: quality.quality.name,
                source: quality.quality.source,
                resolution: quality.quality.resolution
            ),
            size: size,
            ageHours: ageHours,
            ageMinutes: ageMinutes,
            indexer: indexer
        )
    }
}

extension Array where Element == ReleaseEpisodeWorkerDecodable {
    func toDomain() -> [ReleaseResult] { map { $0.toDomain() } }
}
