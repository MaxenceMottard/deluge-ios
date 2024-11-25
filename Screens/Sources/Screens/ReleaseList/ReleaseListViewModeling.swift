//
//  ReleaseListViewModeling.swift
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
protocol ReleaseListViewModeling {
    var title: String { get }
    var isLoading: Bool { get }
    var results: [Release] { get }

    func release() async
    func openInBrowser(release: Release)
    func download(release: Release) async
}

@Observable
@MainActor
class ReleaseListViewModel: ReleaseListViewModeling {
    struct Dependencies {
        let getEpisodeReleasesWorker: GetEpisodeReleasesWorking
        let releaseEpisodeWorker: ReleaseEpisodeWorking
        let openURLWorker: OpenURLWorking
        let router: Routing
    }

    private let dependencies: Dependencies
    private let onDownloadReleaseSuccess: () async -> Void

    let serie: Serie
    let episode: Serie.Episode
    var isLoading: Bool = false
    var results: [Release] = []

    var title: String {
        "\(serie.title) - \(episode.seasonNumber)x\(episode.episodeNumber) - \(episode.title)"
    }

    init(
        dependencies: Dependencies,
        serie: Serie,
        episode: Serie.Episode,
        onDownloadReleaseSuccess: @escaping () async -> Void
    ) {
        self.dependencies = dependencies
        self.episode = episode
        self.serie = serie
        self.onDownloadReleaseSuccess = onDownloadReleaseSuccess
    }

    func release() async {
        do {
            isLoading = true
            self.results = try await dependencies.getEpisodeReleasesWorker.run(id: episode.id)
        } catch {
            print(error)
        }
        isLoading = false
    }

    func openInBrowser(release: Release) {
        guard let url = URL(string: release.infoUrl) else { return }
        dependencies.openURLWorker.open(url: url)
    }

    func download(release: Release) async {
        do {
            try await dependencies.releaseEpisodeWorker.run(
                indexerId: release.indexerId,
                guid: release.guid
            )
            dependencies.router.dismiss()
            await onDownloadReleaseSuccess()
        } catch {
            print(error)
        }
    }
}
