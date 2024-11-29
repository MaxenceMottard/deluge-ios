//
//  MediaDetailsMovieViewModel.swift
//  Screens
//
//  Created by Maxence Mottard on 29/11/2024.
//

import Routing
import Workers
import Foundation

@MainActor
// sourcery: AutoMockable
protocol MediaDetailsMovieViewModel {

}

@Observable
@MainActor
class DefaultMediaDetailsMovieViewModel: MediaDetailsMovieViewModel {
    struct Dependencies {
        let router: Routing
    }

    let movie: Movie
    private let dependencies: Dependencies

    init(movie: Movie, dependencies: Dependencies) {
        self.movie = movie
        self.dependencies = dependencies
    }

}
