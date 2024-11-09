//
//  Serie.swift
//  Workers
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Foundation

public struct Serie: Identifiable, Sendable {
    public let id: Int
    public let title: String
    public let description: String
    public let status: Status
    public let poster: String?
    public let banner: String?

    public enum Status: Sendable {
        case continuing
        case ended
        case upcoming
        case deleted
    }
}

extension GetSeriesWebWorkingResponse {
    func toDomain() -> Serie {
        Serie(
            id: id,
            title: title,
            description: overview,
            status: status.toDomain(),
            poster: images.first(where: { $0.coverType == .poster })?.remoteUrl,
            banner: images.first(where: { $0.coverType == .banner })?.remoteUrl
        )
    }
}

extension GetSeriesWebWorkingResponse.Status {
    func toDomain() -> Serie.Status {
        switch self {
        case .continuing: return .continuing
        case .ended: return .ended
        case .upcoming: return .upcoming
        case .deleted: return .deleted
        }
    }
}

extension Array where Element == GetSeriesWebWorkingResponse {
    func toDomain() -> [Serie] { map { $0.toDomain() } }
}
