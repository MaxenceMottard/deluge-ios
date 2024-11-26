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
                tapticEngineWorker: Dependency.resolve(TapticEngineWorking.self)!,
                systemStatusWebWorker: Dependency.resolve(GetSystemStatusWorking.self)!,
                router: router
            )
        )

        let view = InstanceSelectorView(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        let title: String.LocalizationValue = "instanceSelector.title"
        viewController.title = String(localized: title)
        viewController.navigationItem.largeTitleDisplayMode = .always
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(
            image: UIImage(systemName: "xcross"),
            primaryAction: UIAction { _ in
                router.dismiss()
            }
        )

        return viewController
    }
}
