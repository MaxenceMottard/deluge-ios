//
//  Route+ReleaseResult.swift
//  Trimarr
//
//  Created by Maxence Mottard on 24/11/2024.
//

import Routing
import SwiftUI
import Workers
import Utils

extension Route {
    typealias ReleaseResult = ReleaseResultRoute
}

struct ReleaseResultRoute: Route {
    let serie: Serie
    let episode: Serie.Episode

    func viewController(router: Router) -> UIViewController {
        let viewModel = ReleaseResultViewModel(
            dependencies: ReleaseResultViewModel.Dependencies(
                releaseEpisodeWorker: Dependency.resolve(ReleaseEpisodeWorking.self)!,
                openURLWorker: Dependency.resolve(OpenURLWorking.self)!,
                router: router
            ),
            serie: serie,
            episode: episode
        )

        let view = ReleaseResultView(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        viewController.title = ""
        viewController.navigationItem.largeTitleDisplayMode = .never

        return viewController
    }
}
