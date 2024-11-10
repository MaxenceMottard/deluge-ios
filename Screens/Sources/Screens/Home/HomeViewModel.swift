//
//  HomeViewModel.swift
//  Screens
//
//  Created by Maxence Mottard on 06/11/2024.
//

import Foundation
import Routing
import Utils
import Workers

@Observable
@MainActor
class HomeViewModel {
    struct Dependencies {
        let instanceWorker: InstanceWorking
        let getSeriesWebWorker: GetSeriesWebWorking
        let imageCacheWorker: ImageCacheWorking
        let router: Routing
    }

    private let dependencies: Dependencies

    var selectedInstance: Instance? {
        dependencies.instanceWorker.selectedInstance
    }

    var series: [Serie] = []

    // MARK: State

    // MARK: Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func fetchSeries() async {
        guard selectedInstance != nil else { return }

        do {
            series = try await dependencies.getSeriesWebWorker.run()
            series.forEach { serie in
                Task {
                    await dependencies.imageCacheWorker.cache(string: serie.banner)
                    await dependencies.imageCacheWorker.cache(string: serie.poster)
                }
            }
        } catch {
            series = []
        }
    }

}
