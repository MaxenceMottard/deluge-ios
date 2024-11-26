//
//  Route+Home.swift
//  Screens
//
//  Created by Maxence Mottard on 06/11/2024.
//

import Routing
import Workers
import SwiftUI
import Utils

extension Route {
    typealias Home = HomeRoute
}

struct HomeRoute: Route {
    @MainActor
    func viewController(router: Router) -> UIViewController {
        let viewModel = HomeViewModel(
            dependencies: HomeViewModel.Dependencies(
                instanceWorker: Dependency.resolve(InstanceWorking.self)!,
                getMoviesWorker: Dependency.resolve(GetMoviesbWorking.self)!,
                getSeriesWebWorker: Dependency.resolve(GetSeriesWorking.self)!,
                imageCacheWorker: Dependency.resolve(ImageCacheWorking.self)!,
                router: router
            )
        )

        let view = HomeView(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        let title: String.LocalizationValue = "home.title"
        viewController.title = String(localized: title)
        viewController.navigationItem.largeTitleDisplayMode = .always

        return viewController
    }
}
