//
//  MediaDetailsSerieViewModel.swift
//  Screens
//
//  Created by Maxence Mottard on 21/11/2024.
//

import SwiftUI
import Workers

@Observable
@MainActor
class MediaDetailsSerieViewModel {
    struct Dependencies {
        let getSerieEpisodeWorker: GetSerieEpisodeWebWorking
        let monitorSerieEpisodeWorking: MonitorSerieEpisodeWebWorking
    }

    private let dependencies: Dependencies

    let serie: Workers.Serie
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

    func monitor(episode: SerieEpisode) async {
        await runMonitorWorker(episodes: [episode], monitored: true)
    }

    func monitor(episodes: [SerieEpisode]) async {
        await runMonitorWorker(episodes: episodes, monitored: true)
    }

    func unmonitor(episode: SerieEpisode) async {
        await runMonitorWorker(episodes: [episode], monitored: false)
    }

    func unmonitor(episodes: [SerieEpisode]) async {
        await runMonitorWorker(episodes: episodes, monitored: false)
    }

    private func runMonitorWorker(episodes: [SerieEpisode], monitored: Bool) async {
        do {
            let episodeIds = episodes.map(\.id)
            try await dependencies.monitorSerieEpisodeWorking.run(ids: episodeIds, monitored: monitored)
            await fetchEpisodes()
        } catch {
            print(error)
        }
    }
}
