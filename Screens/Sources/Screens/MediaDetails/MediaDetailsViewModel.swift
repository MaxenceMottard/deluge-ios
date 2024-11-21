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
protocol MediaDetailsViewModeling {
    var media: any Media { get }
}

@Observable
@MainActor
class MediaDetailsViewModel: MediaDetailsViewModeling {
    struct Dependencies {
        let router: Routing
    }

    private let dependencies: Dependencies
    let media: any Media

    init(media: any Media, dependencies: Dependencies) {
        self.media = media
        self.dependencies = dependencies
    }
}
