//
//  MediaDetailsSerieViewModel.swift
//  Screens
//
//  Created by Maxence Mottard on 21/11/2024.
//

import SwiftUI
import Workers
import Utils
import Routing

@MainActor
// sourcery: AutoMockable
protocol MediaDetailsSerieViewModeling {
    var seasons: [Serie.Season] { get }
    var serie: Serie { get }

    func fetchData() async
    func monitor(episodes: [Serie.Episode]) async
    func unmonitor(episodes: [Serie.Episode]) async
    func monitor(season: Serie.Season) async
    func unmonitor(season: Serie.Season) async
    func getSeason(with: Int) -> Serie.Season?
    func getStatus(of season: Serie.Season) -> SeasonStatus
    func getEpisodes(of season: Serie.Season) -> [Serie.Episode]
    func getEpisodeFile(of episode: Serie.Episode) -> Serie.Episode.File?

    func search(episode: Serie.Episode) async
    func release(episode: Serie.Episode) async
}

@Observable
@MainActor
class MediaDetailsSerieViewModel: MediaDetailsSerieViewModeling {
    struct Dependencies {
        let getSerieWorker: GetSerieWorking
        let getEpisodesWorker: GetEpisodesWorking
        let getEpisodesFilesWorking: GetEpisodesFilesWorking
        let monitorEpisodesWorking: MonitorEpisodesWorking
        let monitorSeasonWorker: MonitorSeasonWorking
        let tapticEngineWorker: TapticEngineWorking
        let commandWorker: SonarrCommandWorking
        let router: Routing
    }

    private let dependencies: Dependencies

    var serie: Serie
    var seasons: [Serie.Season] { serie.seasons.sorted { $0.seasonNumber > $1.seasonNumber } }
    var episodes: [Serie.Episode] = []
    var episodesFiles: [Serie.Episode.File] = []

    init(serie: Workers.Serie, dependencies: Dependencies) {
        self.serie = serie
        self.dependencies = dependencies
    }

    func fetchData() async {
        await fetchSerie()
        await fetchEpisodes()
        await fetchEpisodesFiles()
    }

    private func fetchSerie() async {
        do {
            self.serie = try await dependencies.getSerieWorker.run(id: serie.id)
        } catch {

        }
    }

    private func fetchEpisodes() async {
        do {
            self.episodes = try await dependencies.getEpisodesWorker.run(serieId: serie.id)
        } catch {
            self.episodes = []
        }
    }

    private func fetchEpisodesFiles() async {
        do {
            self.episodesFiles = try await dependencies.getEpisodesFilesWorking.run(serieId: serie.id)
        } catch {
            self.episodesFiles = []
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
        await fetchData()
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
        await fetchData()
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

    func getEpisodes(of season: Serie.Season) -> [Serie.Episode] {
        episodes.filter { $0.seasonNumber == season.seasonNumber }
            .sorted { $0.episodeNumber > $1.episodeNumber }
    }

    func getEpisodeFile(of episode: Serie.Episode) -> Serie.Episode.File? {
        episodesFiles.first { $0.id == episode.fileId }
    }

    // MARK: Actions

    func search(episode: Serie.Episode) async {
        do {
            try await dependencies.commandWorker.run(command: .episodeSearch(ids: [episode.id]))
        } catch {
            print(error)
        }
    }

    func release(episode: Serie.Episode) async {
        let route = Route.ReleaseResult(serie: serie, episode: episode)
        dependencies.router.present(route: route, modal: .sheet)
    }
}

enum SeasonStatus: CaseIterable {
    case completed
    case missingMonitored
    case missingNonMonitored
}
