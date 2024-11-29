//
//  DeleteMediaViewModel.swift
//  Screens
//
//  Created by Maxence Mottard on 29/11/2024.
//

import Routing
import Foundation
import Workers

@MainActor
// sourcery: AutoMockable
protocol DeleteMediaViewModel {
    var deleteFiles: Bool { get set }
    var addImportListExclusion: Bool { get set }

    func delete() async
}

@Observable
@MainActor
class DefaultDeleteMediaViewModel: DeleteMediaViewModel {
    struct Dependencies {
        let deleteSerieWorker: DeleteSerieWorking
        let router: Routing
    }

    private let dependencies: Dependencies
    private let media: any Media
    private let onRemove: () -> Void

    var deleteFiles: Bool = false
    var addImportListExclusion: Bool = false

    init(dependencies: Dependencies, media: any Media, onRemove: @escaping () -> Void) {
        self.dependencies = dependencies
        self.media = media
        self.onRemove = onRemove
    }

    func delete() async {
        do {
            if let serie = media as? Serie {
                try await dependencies.deleteSerieWorker.run(
                    id: serie.id,
                    deleteFiles: deleteFiles,
                    addImportListExclusion: addImportListExclusion
                )
            }
            dependencies.router.dismiss()
            onRemove()
        } catch {
            print(error)
        }
    }
}
