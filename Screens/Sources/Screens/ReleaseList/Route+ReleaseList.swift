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
    let title: LocalizedStringKey
    let onDownloadReleaseSuccess: () async -> Void
    let getReleases: () async throws -> [Release]

    func viewController(router: Router) -> UIViewController {
        let viewModel = DefaultReleaseListViewModel(
            dependencies: DefaultReleaseListViewModel.Dependencies(
                releaseEpisodeWorker: Dependency.resolve(ReleaseEpisodeWorking.self)!,
                openURLWorker: Dependency.resolve(OpenURLWorking.self)!,
                router: router
            ),
            title: title,
            onDownloadReleaseSuccess: onDownloadReleaseSuccess,
            getReleases: getReleases
        )

        let view = ReleaseListView(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        viewController.navigationItem.largeTitleDisplayMode = .never

        return viewController
    }
}
