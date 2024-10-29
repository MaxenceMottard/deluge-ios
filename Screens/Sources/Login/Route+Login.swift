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
        let viewModel = LoginViewModel(router: router)
        let view = LoginView(viewModel: viewModel).environmentObject(router)
        let viewController = view.viewController
//        viewController.title = L10n.Search.title
        viewController.navigationItem.largeTitleDisplayMode = .always

        return viewController
    }
}
