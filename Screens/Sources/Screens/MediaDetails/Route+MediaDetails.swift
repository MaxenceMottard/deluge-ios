//
//  Route+MediaDetails.swift
//  Screens
//
//  Created by Maxence Mottard on 10/11/2024.
//

import Routing
import SwiftUI
import Workers
import Utils

extension Route {
    typealias MediaDetails = MediaDetailsRoute
}

struct MediaDetailsRoute: Route {
    let media: any Media

    func viewController(router: Router) -> UIViewController {
        let viewModel = MediaDetailsViewModel(
            media: media,
            dependencies: MediaDetailsViewModel.Dependencies(
                router: router,
                getSerieViewModel: { serie in
                    MediaDetailsSerieViewModel(
                        serie: serie,
                        dependencies: MediaDetailsSerieViewModel.Dependencies(
                            getSerieWorker: Dependency.resolve(GetSerieWorking.self)!,
                            getEpisodesWorker: Dependency.resolve(GetEpisodesWorking.self)!,
                            getEpisodesFilesWorking: Dependency.resolve(GetEpisodesFilesWorking.self)!,
                            monitorEpisodesWorking: Dependency.resolve(MonitorEpisodesWorking.self)!,
                            monitorSeasonWorker: Dependency.resolve(MonitorSeasonWorking.self)!,
                            tapticEngineWorker: Dependency.resolve(TapticEngineWorking.self)!,
                            commandWorker: Dependency.resolve(SonarrCommandWorking.self)!
                        )
                    )
                }
            )
        )

        let view = MediaDetailsView(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        viewController.navigationItem.largeTitleDisplayMode = .never

        return viewController
    }
}
