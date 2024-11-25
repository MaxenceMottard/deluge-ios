//
//  ReleaseResultViewModel.swift
//  Trimarr
//
//  Created by Maxence Mottard on 24/11/2024.
//

import Routing
import Foundation
import Workers
import Utils

@MainActor
// sourcery: AutoMockable
protocol ReleaseResultViewModeling {
    var title: String { get }
    var isLoading: Bool { get }
    var results: [ReleaseResult] { get }

    func release() async
    func openInBrowser(url: String)
}

@Observable
@MainActor
class ReleaseResultViewModel: ReleaseResultViewModeling {
    struct Dependencies {
        let releaseEpisodeWorker: ReleaseEpisodeWorking
        let openURLWorker: OpenURLWorking
        let router: Routing
    }

    private let dependencies: Dependencies

    let serie: Serie
    let episode: Serie.Episode
    var isLoading: Bool = false
    var results: [ReleaseResult] = []

    var title: String {
        "\(serie.title) - \(episode.seasonNumber)x\(episode.episodeNumber) - \(episode.title)"
    }

    init(dependencies: Dependencies, serie: Serie, episode: Serie.Episode) {
        self.dependencies = dependencies
        self.episode = episode
        self.serie = serie
    }

    func release() async {
        do {
            isLoading = true
            self.results = try await dependencies.releaseEpisodeWorker.run(id: episode.id)
        } catch {
            print(error)
        }
        isLoading = false
    }

    func openInBrowser(url: String) {
        guard let url = URL(string: url) else { return }
        dependencies.openURLWorker.open(url: url)
    }
}
