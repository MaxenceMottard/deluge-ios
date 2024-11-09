//
//  InstanceSelectorViewModel.swift
//  Screens
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Foundation
import Utils
import Routing

@Observable
@MainActor
class InstanceSelectorViewModel {
    struct Dependencies {
        let instanceWorker: InstanceWorking
        let router: Routing
    }

    private let dependencies: Dependencies

    // MARK: State
    var instances: [Instance] {
        get { dependencies.instanceWorker.instances.map({ $0 }) }
        set { dependencies.instanceWorker.instances = Set<Instance>(newValue) }
    }

    var selectedInstance: Instance? {
        get { dependencies.instanceWorker.selectedInstance }
        set { dependencies.instanceWorker.selectedInstance = newValue }
    }

    // MARK: Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func addInstance() {
        dependencies.router.present(route: Route.Login(), modal: .sheet)
    }

    func remove(instance: Instance) {
        dependencies.instanceWorker.remove(instance: instance)
    }

}
