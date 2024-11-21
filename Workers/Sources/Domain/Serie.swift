//
//  Serie.swift
//  Workers
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Foundation

public struct Serie: Media {
    public let id: Int
    public let title: String
    public let description: String
    public let year: Int
    public let status: Status
    public let poster: String?
    public let banner: String?

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

    public enum Status: Sendable {
        case continuing
        case ended
        case upcoming
        case deleted
    }
}

extension GetSeriesWebWorkerResponse {
    func toDomain() -> Serie {
        Serie(
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

extension GetSeriesWebWorkerResponse.Status {
    func toDomain() -> Serie.Status {
        switch self {
        case .continuing: return .continuing
        case .ended: return .ended
        case .upcoming: return .upcoming
        case .deleted: return .deleted
        }
    }
}

extension Array where Element == GetSeriesWebWorkerResponse {
    func toDomain() -> [Serie] { map { $0.toDomain() } }
}
