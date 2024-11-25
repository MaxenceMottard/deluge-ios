//
//  Route+ReleaseList.swift
//  Trimarr
//
//  Created by Maxence Mottard on 24/11/2024.
//

import Routing
import SwiftUI
import Workers
import Utils

extension Route {
    typealias ReleaseList = ReleaseListRoute
}

struct ReleaseListRoute: Route {
    let serie: Serie
    let episode: Serie.Episode

    func viewController(router: Router) -> UIViewController {
        let viewModel = ReleaseListViewModel(
            dependencies: ReleaseListViewModel.Dependencies(
                releaseEpisodeWorker: Dependency.resolve(GetEpisodeReleasesWorking.self)!,
                openURLWorker: Dependency.resolve(OpenURLWorking.self)!,
                router: router
            ),
            serie: serie,
            episode: episode
        )

        let view = ReleaseListView(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        viewController.title = ""
        viewController.navigationItem.largeTitleDisplayMode = .never

        return viewController
    }
}