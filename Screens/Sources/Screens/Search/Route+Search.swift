//
//  Route+Search.swift
//  Screens
//
//  Created by Maxence Mottard on 26/11/2024.
//

import Routing
import SwiftUI
import Workers

extension Route {
    typealias Search = SearchRoute
}

struct SearchRoute: Route {
    func viewController(router: Router) -> UIViewController {
        let viewModel = SearchViewModel(
            dependencies: SearchViewModel.Dependencies(
                searchSerieWorker: Dependency.resolve(SearchSerieWorking.self)!,
                router: router
            )
        )

        let searchController = UISearchController(searchResultsController: nil)
        searchController.searchResultsUpdater = viewModel

        let view = SearchView(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        viewController.title = String(localized: "search.title", bundle: .module)
        viewController.navigationItem.largeTitleDisplayMode = .always
        viewController.navigationItem.searchController = searchController

        return viewController
    }
}
