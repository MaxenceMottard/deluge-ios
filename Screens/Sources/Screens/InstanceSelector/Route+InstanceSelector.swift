//
//  Route+InstanceSelector.swift
//  Screens
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Routing
import Workers
import SwiftUI
import Utils

extension Route {
    typealias InstanceSelector = InstanceSelectorRoute
}

struct InstanceSelectorRoute: Route {
    @MainActor
    func viewController(router: Router) -> UIViewController {
        let viewModel = InstanceSelectorViewModel(
            dependencies: InstanceSelectorViewModel.Dependencies(
                instanceWorker: Dependency.resolve(InstanceWorking.self)!,
                systemStatusWebWorker: Dependency.resolve(SystemStatusWebWorking.self)!,
                router: router
            )
        )

        let view = InstanceSelectorView(viewModel: viewModel).environmentObject(router)
        let viewController = view.viewController(
            title: "Instances",
            largeTitleDisplayMode: .always
        )

        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xcross"),
            primaryAction: UIAction { _ in
                router.dismiss()
            }
        )

        return viewController
    }
}
