//
//  ReleaseListViewModel.swift
//  Trimarr
//
//  Created by Maxence Mottard on 24/11/2024.
//

import Routing
import Foundation
import Workers
import Utils
import SwiftUI

@MainActor
// sourcery: AutoMockable
protocol ReleaseListViewModel {
    var title: LocalizedStringKey { get }
    var isLoading: Bool { get }
    var results: [Release] { get }

    func release() async
    func openInBrowser(release: Release)
    func download(release: Release) async
}

@Observable
@MainActor
class DefaultReleaseListViewModel: ReleaseListViewModel {
    struct Dependencies {
        let releaseEpisodeWorker: ReleaseEpisodeWorking
        let openURLWorker: OpenURLWorking
        let router: Routing
    }

    private let dependencies: Dependencies
    private let onDownloadReleaseSuccess: () async -> Void
    private let getReleases: () async throws -> [Release]

    var isLoading: Bool = false
    var results: [Release] = []

    let title: LocalizedStringKey

    init(
        dependencies: Dependencies,
        title: LocalizedStringKey,
        onDownloadReleaseSuccess: @escaping () async -> Void,
        getReleases: @escaping () async throws -> [Release]
    ) {
        self.dependencies = dependencies
        self.title = title
        self.onDownloadReleaseSuccess = onDownloadReleaseSuccess
        self.getReleases = getReleases
    }

    func release() async {
        do {
            isLoading = true
            self.results = try await getReleases()
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
