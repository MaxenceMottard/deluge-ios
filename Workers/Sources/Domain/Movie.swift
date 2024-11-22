//
//  Movie.swift
//  Workers
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Foundation

public struct Movie: Media {
    public let id: Int
    public let title: String
    public let description: String
    public let year: Int
    public let status: Status
    public let poster: String?
    public let banner: String?

    public enum Status: Sendable {
        case tba
        case announced
        case inCinemas
        case released
        case deleted
    }

    public init(
        id: Int,
        title: String,
        description: String,
        year: Int,
        status: Status,
        poster: String?,
        banner: String?
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.year = year
        self.status = status
        self.poster = poster
        self.banner = banner
    }
}

extension GetMoviesWorkerDecodable {
    func toDomain() -> Movie {
        Movie(
            id: id,
            title: title,
            description: overview,
            year: year,
            status: status.toDomain(),
            poster: images.first(where: { $0.coverType == .poster })?.remoteUrl,
            banner: images.first(where: { $0.coverType == .banner })?.remoteUrl
        )
    }
}

extension GetMoviesWorkerDecodable.Status {
    func toDomain() -> Movie.Status {
        switch self {
        case .tba: return .tba
        case .announced: return .announced
        case .inCinemas: return .inCinemas
        case .released: return .released
        case .deleted: return .deleted
        }
    }
}

extension Array where Element == GetMoviesWorkerDecodable {
    func toDomain() -> [Movie] { map { $0.toDomain() } }
}
