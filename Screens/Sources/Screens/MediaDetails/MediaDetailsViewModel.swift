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

    func deleteAction()
    func refreshAction() async
    func automaticSearchAction() async
    func getSerieViewModel(serie: Serie) -> any MediaDetailsSerieViewModel
}

@Observable
@MainActor
class DefaultMediaDetailsViewModel: MediaDetailsViewModel {
    struct Dependencies {
        let commandWorker: SonarrCommandWorking
        let getSerieViewModel: (Serie) -> any MediaDetailsSerieViewModel
        let router: Routing
    }

    private let dependencies: Dependencies
    let media: any Media

    init(media: any Media, dependencies: Dependencies) {
        self.media = media
        self.dependencies = dependencies
    }

    func refreshAction() async {
        do {
            if let serie = media as? Serie {
                try await dependencies.commandWorker.run(command: .refreshSerie(id: serie.id))
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
            if let serie = media as? Serie {
                try await dependencies.commandWorker.run(command: .serieSearch(id: serie.id))
            }
        } catch {
            print(error)
        }
    }

    func getSerieViewModel(serie: Serie) -> any MediaDetailsSerieViewModel {
        dependencies.getSerieViewModel(serie)
    }
}
