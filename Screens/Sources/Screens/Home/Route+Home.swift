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
                getMoviesWorker: Dependency.resolve(GetMoviesWebWorking.self)!,
                getSeriesWebWorker: Dependency.resolve(GetSeriesWebWorking.self)!,
                imageCacheWorker: Dependency.resolve(ImageCacheWorking.self)!,
                router: router
            )
        )

        let view = HomeView(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        viewController.title = "Home"
        viewController.navigationItem.largeTitleDisplayMode = .always
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "server.rack"),
            primaryAction: UIAction { _ in
                router.present(route: Route.InstanceSelector(), modal: .sheet)
            }
        )

        return viewController
    }
}
