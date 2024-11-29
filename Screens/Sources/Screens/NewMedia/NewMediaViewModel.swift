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
    var rootFolders: [RootFolder] { get }
    var selectedRootFolder: RootFolder? { get set }
}

@Observable
@MainActor
class DefaultNewMediaViewModel: NewMediaViewModel {
    struct Dependencies {
        let globalDataRepository: GlobalDataRepository
        let router: Routing
    }

    private let dependencies: Dependencies

    var rootFolders: [RootFolder] {
        dependencies.globalDataRepository.rootFolders
    }

    var selectedRootFolder: RootFolder?

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

}
