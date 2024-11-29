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
protocol MediaDetailsSerieViewModel {
    var seasons: [Serie.Season] { get }
    var serie: Serie { get }

    func fetchData() async
    func monitor(episodes: [Serie.Episode]) async
    func unmonitor(episodes: [Serie.Episode]) async
    func monitor(season: Serie.Season) async
    func unmonitor(season: Serie.Season) async
    func getSeason(with: Int) -> Serie.Season?
    func getStatus(of: Serie.Season) -> SeasonStatus
    func getEpisodes(of: Serie.Season) -> [Serie.Episode]
    func getEpisodeFile(of: Serie.Episode) -> Serie.Episode.File?
    func getQueueItem(of: Serie.Episode) -> Serie.QueueItem?
    func getQueueItems(of season: Serie.Season) -> [Serie.QueueItem]

    func automaticSearch(of: Serie.Episode) async
    func automaticSearch(of: Serie.Season) async
    func interactiveSearch(of: Serie.Episode)
    func interactiveSearch(of: Serie.Season)
}

@Observable
@MainActor
class DefaultMediaDetailsSerieViewModel: MediaDetailsSerieViewModel {
    struct Dependencies {
        let getSerieWorker: GetSerieWorking
        let getEpisodesWorker: GetEpisodesWorking
        let getEpisodesFilesWorking: GetEpisodesFilesWorking
        let monitorEpisodesWorking: MonitorEpisodesWorking
        let monitorSeasonWorker: MonitorSeasonWorking
        let tapticEngineWorker: TapticEngineWorking
        let commandWorker: SonarrCommandWorking
        let getSerieQueueWorker: GetSerieQueueWorking
        let getSeasonReleasesWorker: GetSeasonReleasesWorking
        let getEpisodeReleasesWorker: GetEpisodeReleasesWorking
        let router: Routing
    }

    private let dependencies: Dependencies

    var serie: Serie
    var seasons: [Serie.Season] { serie.seasons.sorted { $0.seasonNumber > $1.seasonNumber } }
    var episodes: [Serie.Episode] = []
    var episodesFiles: [Serie.Episode.File] = []
    var queueItems: [Serie.QueueItem] = []

    init(serie: Workers.Serie, dependencies: Dependencies) {
        self.serie = serie
        self.dependencies = dependencies
    }

    func fetchData() async {
        await fetchSerie()
        await fetchEpisodes()
        await fetchEpisodesFiles()
        await fetchSerieQueue()
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

    private func fetchSerieQueue() async {
        do {
            self.queueItems = try await dependencies.getSerieQueueWorker.run(id: serie.id)
        } catch {
            self.queueItems = []
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
        if !getQueueItems(of: season).isEmpty {
            return .queued
        }

        return if season.episodeFileCount < season.episodeCount {
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

    func getQueueItem(of episode: Serie.Episode) -> Serie.QueueItem? {
        queueItems.first { $0.episodeId == episode.id }
    }

    func getQueueItems(of season: Serie.Season) -> [Serie.QueueItem] {
        queueItems.filter { $0.seasonNumber == season.seasonNumber }
    }

    // MARK: Actions

    func automaticSearch(of episode: Serie.Episode) async {
        do {
            try await dependencies.commandWorker.run(command: .episodeSearch(ids: [episode.id]))
        } catch {
            print(error)
        }
    }

    func automaticSearch(of season: Serie.Season) async {
        do {
            try await dependencies.commandWorker.run(command: .seasonSearch(
                serieId: serie.id,
                seasonNumber: season.seasonNumber
            ))
        } catch {
            print(error)
        }
    }

    func interactiveSearch(of episode: Serie.Episode) {
        let route = Route.ReleaseList(
            title: "releaseList.title.episode \(serie.title) \(episode.seasonNumber) \(episode.episodeNumber) \(episode.title)",
            onDownloadReleaseSuccess: { [weak self] in
                await self?.fetchData()
            },
            getReleases: { [dependencies] in
                try await dependencies.getEpisodeReleasesWorker.run(id: episode.id)
            }

        )
        dependencies.router.present(route: route, modal: .sheet)
    }

    func interactiveSearch(of season: Serie.Season) {
        let route = Route.ReleaseList(
            title: "releaseList.title.season \(serie.title) \(season.seasonNumber)",
            onDownloadReleaseSuccess: { [weak self] in
                await self?.fetchData()
            },
            getReleases: { [dependencies, serie] in
                try await dependencies.getSeasonReleasesWorker.run(
                    serieId: serie.id,
                    seasonNumber: season.seasonNumber
                )
            }
        )
        dependencies.router.present(route: route, modal: .sheet)
    }
}

enum SeasonStatus: CaseIterable {
    case completed
    case missingMonitored
    case missingNonMonitored
    case queued
}
