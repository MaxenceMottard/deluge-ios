//
//  MediaDetailsViewModel.swift
//  Screens
//
//  Created by Maxence Mottard on 10/11/2024.
//

import Workers
import Routing
import Foundation

@Observable
@MainActor
class MediaDetailsViewModel {
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
