//
//  Route+NewInstance.swift
//  Screens
//
//  Created by Maxence Mottard on 28/10/2024.
//

import Routing
import Workers
import SwiftUI
import Utils

extension Route {
    typealias NewInstance = NewInstanceRoute
}

struct NewInstanceRoute: Route {
    @MainActor
    func viewController(router: Router) -> UIViewController {
        let viewModel = NewInstanceViewModel(
            dependencies: NewInstanceViewModel.Dependencies(
                checkConfigurationWebWorker: Dependency.resolve(GetSystemStatusWorking.self)!,
                instanceWorker: Dependency.resolve(InstanceWorking.self)!,
                tapticEngineWorker: Dependency.resolve(TapticEngineWorking.self)!,
                router: router
            )
        )
        let view = NewInstanceView(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        let title: String.LocalizationValue = "newInstance.title"
        viewController.navigationItem.largeTitleDisplayMode = .always

        return viewController
    }
}
