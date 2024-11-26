//
//  SearchViewModel.swift
//  Screens
//
//  Created by Maxence Mottard on 26/11/2024.
//

import Routing
import Foundation
import UIKit
import Workers

@MainActor
// sourcery: AutoMockable
protocol SearchViewModel {
    var isLoading: Bool { get }
    var searchResults: [SearchSerieResult] { get }
}

@Observable
@MainActor
class DefaultSearchViewModel: NSObject, SearchViewModel  {
    private enum Constants {
        static let searchDelay: TimeInterval = 0.5
    }

    struct Dependencies {
        let searchSerieWorker: SearchSerieWorking
        let router: Routing
    }

    private let dependencies: Dependencies

    private var searchTask: Task<Void, Never>?
    var searchText: String? {
        didSet {
            runSearchTask()
        }
    }

    var isLoading: Bool = false
    var searchResults: [SearchSerieResult] = []

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    private func runSearchTask() {
        searchTask?.cancel()

        guard let searchText, !searchText.isEmpty else { return }

        isLoading = true
        searchTask = Task { [weak self] in
            try? await Task.sleep(nanoseconds: UInt64(Constants.searchDelay * 1_000_000_000))
            guard !Task.isCancelled else { return }
            await self?.performSearch(search: searchText)
        }
    }

    private func performSearch(search: String) async {
        do {
            searchResults = try await dependencies.searchSerieWorker.run(search: search)
        } catch {
            searchResults = []
        }
        isLoading = false
    }
}

extension DefaultSearchViewModel: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        searchText = searchController.searchBar.text
    }
}
