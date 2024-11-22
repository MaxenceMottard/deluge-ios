//
//  MediaDetailsSerieViewModel.swift
//  Screens
//
//  Created by Maxence Mottard on 21/11/2024.
//

import SwiftUI
import Workers
import Utils

@MainActor
// sourcery: AutoMockable
protocol MediaDetailsSerieViewModeling {
    var serie: Serie { get }
    var seasons: [(key: Int, value: [SerieEpisode])] { get }

    func fetchEpisodes() async
    func monitor(episodes: [SerieEpisode]) async
    func unmonitor(episodes: [SerieEpisode]) async
    func getSeason(with: Int) -> Serie.Season?
    func getStatus(of season: Serie.Season) -> SeasonStatus
}

@Observable
@MainActor
class MediaDetailsSerieViewModel: MediaDetailsSerieViewModeling {
    struct Dependencies {
        let getSerieEpisodeWorker: GetSerieEpisodeWebWorking
        let monitorSerieEpisodeWorking: MonitorSerieEpisodeWebWorking
        let tapticEngineWorker: TapticEngineWorking
    }

    private let dependencies: Dependencies

    let serie: Serie
    var seasons: [(key: Int, value: [SerieEpisode])] = []

    init(serie: Workers.Serie, dependencies: Dependencies) {
        self.serie = serie
        self.dependencies = dependencies
    }

    func fetchEpisodes() async {
        do {
            let episodes = try await dependencies.getSerieEpisodeWorker.run(id: serie.id)
            // group episodes by seasons, seasons should be sorted descending by seasonNumber, and epiosde should be sorted ascending by episodeNumber result should be a dictionary
            seasons = Dictionary(grouping: episodes, by: { $0.seasonNumber })
                .mapValues { $0.sorted(by: { $0.episodeNumber > $1.episodeNumber }) }
                .sorted(by: { $0.key > $1.key })
        } catch {
            seasons = []
        }
    }

    func monitor(episodes: [SerieEpisode]) async {
        await runMonitorWorker(episodes: episodes, monitored: true)
    }

    func unmonitor(episodes: [SerieEpisode]) async {
        await runMonitorWorker(episodes: episodes, monitored: false)
    }

    private func runMonitorWorker(episodes: [SerieEpisode], monitored: Bool) async {
        do {
            let episodeIds = episodes.map(\.id)
            try await dependencies.monitorSerieEpisodeWorking.run(ids: episodeIds, monitored: monitored)
            dependencies.tapticEngineWorker.trigger(type: .success)
            await fetchEpisodes()
        } catch {
            print(error)
        }
    }

    func getSeason(with seasonNumber: Int) -> Serie.Season? {
        serie.seasons.first { $0.seasonNumber == seasonNumber }
    }

    func getStatus(of season: Serie.Season) -> SeasonStatus {
        if season.episodeFileCount < season.episodeCount {
            .missingMonitored
        } else if season.episodeFileCount == season.episodeCount && season.episodeFileCount > 0 {
            .completed
        } else {
            .missingNonMonitored
        }
    }
}

enum SeasonStatus: CaseIterable {
    case completed
    case missingMonitored
    case missingNonMonitored
}
