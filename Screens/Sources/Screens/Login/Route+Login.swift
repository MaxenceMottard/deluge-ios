//
//  File.swift
//  Screens
//
//  Created by Maxence Mottard on 28/10/2024.
//

import Routing
import Workers
import SwiftUI
import Utils

extension Route {
    typealias Login = LoginRoute
}

struct LoginRoute: Route {
    @MainActor
    func viewController(router: Router) -> UIViewController {
        let viewModel = LoginViewModel(
            dependencies: LoginViewModel.Dependencies(
                checkConfigurationWebWorker: Dependency.resolve(CheckConfigurationWebWorking.self)!,
                instanceWorker: Dependency.resolve(InstanceWorking.self)!,
                router: router
            )
        )
        let view = LoginView(viewModel: viewModel).environmentObject(router)
        let viewController = view.viewController(
            title: "",
            largeTitleDisplayMode: .always
        )

        return viewController
    }
}
