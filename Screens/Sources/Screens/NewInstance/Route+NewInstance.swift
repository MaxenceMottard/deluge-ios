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
        let viewModel = DefaultNewInstanceViewModel(
            dependencies: DefaultNewInstanceViewModel.Dependencies(
                checkConfigurationWebWorker: Dependency.resolve(GetSystemStatusWorking.self)!,
                instanceRepository: Dependency.resolve(InstanceRepository.self)!,
                tapticEngineWorker: Dependency.resolve(TapticEngineWorking.self)!,
                router: router
            )
        )
        let view = NewInstanceView(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        viewController.title = String(localized: "newInstance.title", bundle: .module)
        viewController.navigationItem.largeTitleDisplayMode = .always

        return viewController
    }
}
