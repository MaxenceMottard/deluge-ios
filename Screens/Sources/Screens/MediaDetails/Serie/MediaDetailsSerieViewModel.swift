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
    var seasons: [(key: Int, value: [Serie.Episode])] { get }

    func fetchEpisodes() async
    func fetchSerie() async
    func monitor(episodes: [Serie.Episode]) async
    func unmonitor(episodes: [Serie.Episode]) async
    func monitor(season: Serie.Season) async
    func unmonitor(season: Serie.Season) async
    func getSeason(with: Int) -> Serie.Season?
    func getStatus(of season: Serie.Season) -> SeasonStatus
}

@Observable
@MainActor
class MediaDetailsSerieViewModel: MediaDetailsSerieViewModeling {
    struct Dependencies {
        let getSerieWorker: GetSerieWorking
        let getEpisodesWorker: GetEpisodesWorking
        let monitorEpisodesWorking: MonitorEpisodesWorking
        let monitorSeasonWorker: MonitorSeasonWorking
        let tapticEngineWorker: TapticEngineWorking
    }

    private let dependencies: Dependencies

    var serie: Serie
    var seasons: [(key: Int, value: [Serie.Episode])] = []

    init(serie: Workers.Serie, dependencies: Dependencies) {
        self.serie = serie
        self.dependencies = dependencies
    }

    func fetchSerie() async {
        do {
            self.serie = try await dependencies.getSerieWorker.run(id: serie.id)
        } catch {

        }
    }

    func fetchEpisodes() async {
        do {
            let episodes = try await dependencies.getEpisodesWorker.run(id: serie.id)
            // group episodes by seasons, seasons should be sorted descending by seasonNumber, and epiosde should be sorted ascending by episodeNumber result should be a dictionary
            seasons = Dictionary(grouping: episodes, by: { $0.seasonNumber })
                .mapValues { $0.sorted(by: { $0.episodeNumber > $1.episodeNumber }) }
                .sorted(by: { $0.key > $1.key })
        } catch {
            seasons = []
        }
    }

    func monitor(season: Serie.Season) async {
        await runMonitorSeasonWorker(season: season, monitored: true)
    }

    func unmonitor(season: Serie.Season) async {
        await runMonitorSeasonWorker(season: season, monitored: false)
    }

    private func runMonitorSeasonWorker(season: Serie.Season, monitored: Bool) async {
        do {
            try await dependencies.monitorSeasonWorker.run(
                serieId: serie.id,
                seasonNumber: season.seasonNumber,
                monitored: monitored
            )
            dependencies.tapticEngineWorker.triggerNotification(type: .success)
        } catch {
            dependencies.tapticEngineWorker.triggerNotification(type: .error)
        }
        await fetchSerie()
        await fetchEpisodes()
    }

    func monitor(episodes: [Serie.Episode]) async {
        await runMonitorEpisodesWorker(episodes: episodes, monitored: true)
    }

    func unmonitor(episodes: [Serie.Episode]) async {
        await runMonitorEpisodesWorker(episodes: episodes, monitored: false)
    }

    private func runMonitorEpisodesWorker(episodes: [Serie.Episode], monitored: Bool) async {
        do {
            let episodeIds = episodes.map(\.id)
            try await dependencies.monitorEpisodesWorking.run(ids: episodeIds, monitored: monitored)
            dependencies.tapticEngineWorker.triggerNotification(type: .success)
        } catch {
            dependencies.tapticEngineWorker.triggerNotification(type: .error)
        }
        await fetchEpisodes()
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
