//
//  MediaDetailsViewModel.swift
//  Screens
//
//  Created by Maxence Mottard on 10/11/2024.
//

import Workers
import Routing
import Foundation

@MainActor
// sourcery: AutoMockable
protocol MediaDetailsViewModel {
    var media: any Media { get }
    var getSerieViewModel: (Serie) -> any MediaDetailsSerieViewModel { get }
    var getMovieViewModel: (Movie) -> any MediaDetailsMovieViewModel { get }

    func deleteAction()
    func refreshAction() async
    func automaticSearchAction() async
    func interactiveSearchAction()
}

@Observable
@MainActor
class DefaultMediaDetailsViewModel: MediaDetailsViewModel {
    struct Dependencies {
        let sonarrCommandWorker: SonarrCommandWorking
        let radarrCommandWorker: RadarrCommandWorking
        let getMovieReleasesWorker: GetMovieReleasesWorking
        let router: Routing
    }

    private let dependencies: Dependencies
    let getSerieViewModel: (Serie) -> any MediaDetailsSerieViewModel
    let getMovieViewModel: (Movie) -> any MediaDetailsMovieViewModel
    let media: any Media

    init(
        media: any Media,
        getSerieViewModel: @escaping (Serie) -> any MediaDetailsSerieViewModel,
        getMovieViewModel: @escaping (Movie) -> any MediaDetailsMovieViewModel,
        dependencies: Dependencies
    ) {
        self.media = media
        self.getSerieViewModel = getSerieViewModel
        self.getMovieViewModel = getMovieViewModel
        self.dependencies = dependencies
    }

    func refreshAction() async {
        do {
            if let media = media as? Serie {
                try await dependencies.sonarrCommandWorker.run(command: .refreshSerie(id: media.id))
            } else if let media = media as? Movie {
                try await dependencies.radarrCommandWorker.run(command: .refreshMovie(id: media.id))
            }
        } catch {
            print(error)
        }
    }

    func deleteAction() {
        let route = Route.DeleteMedia(
            media: media,
            onRemove: { [dependencies] in
                dependencies.router.dismiss()
            }
        )
        dependencies.router.present(route: route, modal: .sheet)
    }

    func automaticSearchAction() async {
        do {
            if let media = media as? Serie {
                try await dependencies.sonarrCommandWorker.run(command: .searchSerie(id: media.id))
            } else if let media = media as? Movie {
                try await dependencies.radarrCommandWorker.run(command: .serachMovie(id: media.id))
            }
        } catch {
            print(error)
        }
    }

    func interactiveSearchAction() {
        guard let media = media as? Movie else { return }
        let route = Route.ReleaseList(
            title: "releaseList.title.movie \(media.title)",
            onDownloadReleaseSuccess: {},
            getReleases: { [dependencies] in
                try await dependencies.getMovieReleasesWorker.run(id: media.id)
            }
        )
        dependencies.router.present(route: route, modal: .sheet)
    }
}
