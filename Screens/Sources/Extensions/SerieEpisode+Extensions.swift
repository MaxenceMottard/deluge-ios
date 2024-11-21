//
//  SerieEpisode+Extensions.swift
//  Screens
//
//  Created by Maxence Mottard on 21/11/2024.
//

import Foundation
import Workers

extension [SerieEpisode] {
    var totalEpisodes: Int {
        count
    }

    var downloadedEpisodes: Int {
        filter(\.hasFile).count
    }

    var monitoredEpisodes: Int {
        let today = Date()
        
        return filter { episode in
            if episode.hasFile { return true }
            guard let diffusionDate = episode.diffusionDate else { return false }
            return episode.monitored && diffusionDate < today
        }
        .count
    }

    var status: SeasonStatus {
        if downloadedEpisodes < monitoredEpisodes {
            .missingMonitored
        } else if downloadedEpisodes == monitoredEpisodes && downloadedEpisodes > 0 {
            .completed
        } else if downloadedEpisodes == monitoredEpisodes && map(\.monitored).contains(true) {
            .missingMonitored
        } else {
            .missingNonMonitored
        }
    }
}

enum SeasonStatus {
    case completed
    case missingMonitored
    case missingNonMonitored
}
