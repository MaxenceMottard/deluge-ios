//
//  Serie+QueueItem.swift
//  Workers
//
//  Created by Maxence Mottard on 25/11/2024.
//

import Foundation

extension Serie {
    public struct QueueItem: Identifiable, Sendable {
        public let id: Int
        public let seriesId: Int
        public let episodeId: Int
        public let seasonNumber: Int
        public let status: String

        public init(
            id: Int,
            seriesId: Int,
            episodeId: Int,
            seasonNumber: Int,
            status: String
        ) {
            self.id = id
            self.seriesId = seriesId
            self.episodeId = episodeId
            self.seasonNumber = seasonNumber
            self.status = status
        }
    }
}

extension GetSerieQueueWorkerDecodable {
    func toDomain() -> Serie.QueueItem {
        Serie.QueueItem(
            id: id,
            seriesId: seriesId,
            episodeId: episodeId,
            seasonNumber: seasonNumber,
            status: status
        )
    }
}

extension [GetSerieQueueWorkerDecodable] {
    func toDomain() -> [Serie.QueueItem] {
        self.map { $0.toDomain() }
    }
}
