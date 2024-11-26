//
//  SearchSerieResult.swift
//  Workers
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Foundation

public struct SearchSerieResult: Sendable, Hashable {
    public let title: String
    public let description: String?
    public let year: Int
    public let poster: String?
    public let banner: String?
//    public let seasons: [Season]

    public init(
        title: String,
        description: String?,
        year: Int,
        poster: String?,
        banner: String?
//        seasons: [Season]
    ) {
        self.title = title
        self.description = description
        self.year = year
        self.poster = poster
        self.banner = banner
//        self.seasons = seasons
    }
}

extension SearchSerieWorkerDecodable {
    func toDomain() -> SearchSerieResult {
        SearchSerieResult(
            title: title,
            description: overview,
            year: year,
            poster: images.first(where: { $0.coverType == .poster })?.remoteUrl,
            banner: images.first(where: { $0.coverType == .banner })?.remoteUrl
//            seasons: seasons.map {
//                Serie.Season(
//                    seasonNumber: $0.seasonNumber,
//                    isMonitored: $0.monitored
//                )
//            }
        )
    }
}

extension Array where Element == SearchSerieWorkerDecodable {
    func toDomain() -> [SearchSerieResult] { map { $0.toDomain() } }
}
