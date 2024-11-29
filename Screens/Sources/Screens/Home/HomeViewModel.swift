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
protocol HomeViewModel {
    var selectedInstance: Instance? { get }
    var medias: [any Media] { get }

    func present(media: any Media)
    func fetch() async
    func presentInstanceSelector()
}

@Observable
@MainActor
class DefaultHomeViewModel: HomeViewModel {
    struct Dependencies {
        let instanceRepository: InstanceRepository
        let getMoviesWorker: GetMoviesbWorking
        let getSeriesWebWorker: GetSeriesWorking
        let imageCacheWorker: ImageCacheWorking
        let globalDataRepository: GlobalDataRepository
        let router: Routing
    }

    private let dependencies: Dependencies

    // MARK: State

    var selectedInstance: Instance? {
        dependencies.instanceRepository.selectedInstance
    }

    var medias: [any Media] = []

    // MARK: Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func present(media: any Media) {
        dependencies.router.navigate(to: Route.MediaDetails(media: media))
    }

    func fetch() async {
        await fetchMedias()
        await dependencies.globalDataRepository.fetch()
    }

    private func fetchMedias() async {
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
