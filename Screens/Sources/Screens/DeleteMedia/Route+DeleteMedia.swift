//
//  Route+DeleteMedia.swift
//  Screens
//
//  Created by Maxence Mottard on 29/11/2024.
//

import Routing
import SwiftUI
import Workers

extension Route {
    typealias DeleteMedia = DeleteMediaRoute
}

struct DeleteMediaRoute: Route {
    let detents: [UISheetPresentationController.Detent] = [.medium()]

    let media: any Media
    let onRemove: () -> Void

    func viewController(router: Router) -> UIViewController {
        let viewModel = DefaultDeleteMediaViewModel(
            dependencies: DefaultDeleteMediaViewModel.Dependencies(
                deleteSerieWorker: Dependency.resolve(DeleteSerieWorking.self)!,
                deleteMovieWorker: Dependency.resolve(DeleteMovieWorking.self)!,
                router: router
            ),
            media: media,
            onRemove: onRemove
        )

        let view = DeleteMediaView(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        viewController.title = String(localized: "deleteMedia.title \(media.title)", bundle: .module)
        viewController.navigationItem.largeTitleDisplayMode = .never

        return viewController
    }
}
