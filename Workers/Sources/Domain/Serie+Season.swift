//
//  Season.swift
//  Workers
//
//  Created by Maxence Mottard on 22/11/2024.
//

import Foundation

extension Serie {
    public struct Season: Sendable, Identifiable {
        public let seasonNumber: Int
        public let isMonitored: Bool
        public let episodeFileCount: Int
        public let episodeCount: Int
        public let totalEpisodeCount: Int
        public let sizeOnDisk: Int

        public var id: Int { seasonNumber }

        public init(
            seasonNumber: Int,
            isMonitored: Bool,
            episodeFileCount: Int,
            episodeCount: Int,
            totalEpisodeCount: Int,
            sizeOnDisk: Int
        ) {
            self.seasonNumber = seasonNumber
            self.isMonitored = isMonitored
            self.episodeFileCount = episodeFileCount
            self.episodeCount = episodeCount
            self.totalEpisodeCount = totalEpisodeCount
            self.sizeOnDisk = sizeOnDisk
        }
    }
}
