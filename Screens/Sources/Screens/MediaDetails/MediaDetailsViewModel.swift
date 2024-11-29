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

    func getSerieViewModel(serie: Serie) -> any MediaDetailsSerieViewModel
}

@Observable
@MainActor
class DefaultMediaDetailsViewModel: MediaDetailsViewModel {
    struct Dependencies {
        let router: Routing
        let getSerieViewModel: (Serie) -> any MediaDetailsSerieViewModel
    }

    private let dependencies: Dependencies
    let media: any Media

    init(media: any Media, dependencies: Dependencies) {
        self.media = media
        self.dependencies = dependencies
    }

    func getSerieViewModel(serie: Serie) -> any MediaDetailsSerieViewModel {
        dependencies.getSerieViewModel(serie)
    }
}
