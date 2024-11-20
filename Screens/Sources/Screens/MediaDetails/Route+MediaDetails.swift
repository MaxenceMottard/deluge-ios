//
//  Route+MediaDetails.swift
//  Screens
//
//  Created by Maxence Mottard on 10/11/2024.
//

import Routing
import SwiftUI
import Workers

extension Route {
    typealias MediaDetails = MediaDetailsRoute
}

struct MediaDetailsRoute: Route {
    let media: any Media

    func viewController(router: Router) -> UIViewController {
        let viewModel = MediaDetailsViewModel(
            media: media,
            dependencies: MediaDetailsViewModel.Dependencies(
                router: router
            )
        )

        let view = MediaDetailsView(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        viewController.navigationItem.largeTitleDisplayMode = .never

        return viewController
    }
}
