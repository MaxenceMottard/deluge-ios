//
//  HomeViewModel.swift
//  Screens
//
//  Created by Maxence Mottard on 06/11/2024.
//

import Foundation
import Routing
import Utils
import Workers

@MainActor
// sourcery: AutoMockable
protocol HomeViewModeling {
    var selectedInstance: Instance? { get }
    var medias: [any Media] { get }

    func present(media: any Media)
    func fetchMedias() async
    func presentInstanceSelector()
}

@Observable
@MainActor
class HomeViewModel: HomeViewModeling {
    struct Dependencies {
        let instanceWorker: InstanceWorking
        let getMoviesWorker: GetMoviesWebWorking
        let getSeriesWebWorker: GetSeriesWebWorking
        let imageCacheWorker: ImageCacheWorking
        let router: Routing
    }

    private let dependencies: Dependencies

    // MARK: State

    var selectedInstance: Instance? {
        dependencies.instanceWorker.selectedInstance
    }

    var medias: [any Media] = []

    // MARK: Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func present(media: any Media) {
        dependencies.router.navigate(to: Route.MediaDetails(media: media))
    }

    func fetchMedias() async {
        guard let selectedInstance else { return }

        do {
            let worker: () async throws -> [any Media] = switch selectedInstance.type {
            case .sonarr:
                dependencies.getSeriesWebWorker.run
            case .radarr:
                dependencies.getMoviesWorker.run
            }

            medias = try await worker()
            medias.forEach { media in
                Task {
                    await dependencies.imageCacheWorker.cache(string: media.banner)
                    await dependencies.imageCacheWorker.cache(string: media.poster)
                }
            }
        } catch {
            medias = []
        }
    }

    func presentInstanceSelector() {
        dependencies.router.present(route: Route.InstanceSelector(), modal: .sheet)
    }
}
