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
    let onDownloadReleaseSuccess: () async -> Void

    func viewController(router: Router) -> UIViewController {
        let viewModel = DefaultReleaseListViewModel(
            dependencies: DefaultReleaseListViewModel.Dependencies(
                getEpisodeReleasesWorker: Dependency.resolve(GetEpisodeReleasesWorking.self)!,
                releaseEpisodeWorker: Dependency.resolve(ReleaseEpisodeWorking.self)!,
                openURLWorker: Dependency.resolve(OpenURLWorking.self)!,
                router: router
            ),
            serie: serie,
            episode: episode,
            onDownloadReleaseSuccess: onDownloadReleaseSuccess
        )

        let view = ReleaseListView(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        viewController.navigationItem.largeTitleDisplayMode = .never

        return viewController
    }
}
