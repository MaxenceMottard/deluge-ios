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
    let data: [String: any Sendable]?

    public init(
        title: String,
        description: String?,
        year: Int,
        poster: String?,
        banner: String?,
        data: [String: any Sendable]?
    ) {
        self.title = title
        self.description = description
        self.year = year
        self.poster = poster
        self.banner = banner
        self.data = data
    }

    public static func == (lhs: SearchSerieResult, rhs: SearchSerieResult) -> Bool {
        lhs.title == rhs.title &&
        lhs.description == rhs.description &&
        lhs.year == rhs.year &&
        lhs.poster == rhs.poster &&
        lhs.banner == rhs.banner
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(title)
        hasher.combine(description)
        hasher.combine(year)
        hasher.combine(poster)
        hasher.combine(banner)
    }
}

extension SearchSerieWorkerDecodable {
    func toDomain(data: [String: any Sendable]?) -> SearchSerieResult {
        SearchSerieResult(
            title: title,
            description: overview,
            year: year,
            poster: images.first(where: { $0.coverType == .poster })?.remoteUrl,
            banner: images.first(where: { $0.coverType == .banner })?.remoteUrl,
            data: data
        )
    }
}
