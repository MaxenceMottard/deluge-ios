//
//  NewMediaViewModel.swift
//  Screens
//
//  Created by Maxence Mottard on 27/11/2024.
//

import Routing
import Foundation
import Workers

@MainActor
// sourcery: AutoMockable
protocol NewMediaViewModel {
    var searchResult: SearchResult { get }
    var rootFolders: [RootFolder] { get }
    var qualityProfiles: [QualityProfile] { get }
    var selectedRootFolder: RootFolder? { get set }
    var selectedQualityProfile: QualityProfile? { get set }
    var selectedMonitorType: SerieMonitor { get set }
    var selectedSerieType: SerieType { get set }
    var isSeasonFolderOn: Bool { get set }
    var searchForMissingEpisodes: Bool { get set }
    var searchForCutoffUnmetEpisodes: Bool { get set }
    var tagsTextfield: String { get set }

    func addMedia() async
}

@Observable
@MainActor
class DefaultNewMediaViewModel: NewMediaViewModel {
    struct Dependencies {
        let globalDataRepository: GlobalDataRepository
        let addSerieWorker: AddSerieWorking
        let router: Routing
    }

    private let dependencies: Dependencies
    let searchResult: SearchResult

    var rootFolders: [RootFolder] {
        dependencies.globalDataRepository.rootFolders
    }

    var qualityProfiles: [QualityProfile] {
        dependencies.globalDataRepository.qualityProfiles
    }

    var selectedRootFolder: RootFolder?
    var selectedQualityProfile: QualityProfile?
    var selectedMonitorType: SerieMonitor = .all
    var selectedSerieType: SerieType = .standard
    var tagsTextfield: String = ""
    var isSeasonFolderOn: Bool = true
    var searchForMissingEpisodes: Bool = true
    var searchForCutoffUnmetEpisodes: Bool = false

    init(dependencies: Dependencies, searchResult: SearchResult) {
        self.dependencies = dependencies
        self.searchResult = searchResult
    }

    func addMedia() async {
        do {
            guard
                let selectedRootFolder,
                let selectedQualityProfile else {
                return
            }

            try await dependencies.addSerieWorker.run(
                serie: searchResult,
                root: selectedRootFolder.path,
                qualityProfileId: selectedQualityProfile.id,
                monitor: selectedMonitorType,
                serieType: selectedSerieType,
                seasonFolder: isSeasonFolderOn,
                searchForMissingEpisodes: searchForMissingEpisodes,
                searchForCutoffUnmetEpisodes: searchForCutoffUnmetEpisodes
            )
            dependencies.router.dismiss()
        } catch {
            print(error)
        }
    }
}
