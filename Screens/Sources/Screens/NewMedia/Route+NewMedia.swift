//
//  Route+NewMedia.swift
//  Screens
//
//  Created by Maxence Mottard on 27/11/2024.
//

import Routing
import SwiftUI
import Workers

extension Route {
    typealias NewMedia = NewMediaRoute
}

struct NewMediaRoute: Route {
    let searchResult: SearchSerieResult

    let detents: [UISheetPresentationController.Detent] = [.medium()]

    func viewController(router: Router) -> UIViewController {
        let viewModel = DefaultNewMediaViewModel(
            dependencies: DefaultNewMediaViewModel.Dependencies(
                globalDataRepository: Dependency.resolve(GlobalDataRepository.self)!,
                addSerieWorker: Dependency.resolve(AddSerieWorking.self)!,
                router: router
            ),
            searchResult: searchResult
        )

        let view = NewMediaView(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        viewController.title = searchResult.title
        viewController.navigationItem.largeTitleDisplayMode = .never

        return viewController
    }
}
