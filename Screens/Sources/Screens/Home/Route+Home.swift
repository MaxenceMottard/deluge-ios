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
                getSeriesWebWorker: Dependency.resolve(GetSeriesWebWorking.self)!,
                router: router
            ),
            instanceSelectorViewModel: InstanceSelectorViewModel(
                dependencies: InstanceSelectorViewModel.Dependencies(
                    instanceWorker: Dependency.resolve(InstanceWorking.self)!,
                    router: router
                )
            )
        )

        let view = HomeView(viewModel: viewModel).environmentObject(router)
        let viewController = view.viewController(
            title: "",
            largeTitleDisplayMode: .never
        )

        return viewController
    }
}
