//
//  Serie+Season+Preview.swift
//  Screens
//
//  Created by Maxence Mottard on 10/11/2024.
//

import Foundation
import Utils

public extension Serie.Season {
    static func preview(
        seasonNumber: Int = 1,
        isMonitored: Bool = true,
        episodeFileCount: Int = 3,
        episodeCount: Int = 5,
        totalEpisodeCount: Int = 8,
        sizeOnDisk: Int = 31312462
    ) -> Serie.Season {
        return Serie.Season(
            seasonNumber: seasonNumber,
            isMonitored: isMonitored,
            episodeFileCount: episodeFileCount,
            episodeCount: episodeCount,
            totalEpisodeCount: totalEpisodeCount,
            sizeOnDisk: sizeOnDisk
        )
    }
}
