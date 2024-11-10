//
//  InstanceSelectorViewModel.swift
//  Screens
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Foundation
import Utils
import Routing
import Workers

@Observable
@MainActor
class InstanceSelectorViewModel {
    struct Dependencies {
        let instanceWorker: InstanceWorking
        let systemStatusWebWorker: SystemStatusWebWorking
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

    private var instanceStatus: [InstanceStatus] = []

    // MARK: Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func addInstance() {
        dependencies.router.present(route: Route.NewInstance(), modal: .sheet)
    }

    func remove(instance: Instance) {
        dependencies.instanceWorker.remove(instance: instance)
    }

    func status(for instance: Instance) -> InstanceStatus? {
        instanceStatus.first(where: { $0.instanceId == instance.id })
    }

    func fetchInstanceSatus() async {
        for instance in instances {
            do {
                let systemStatus = try await dependencies.systemStatusWebWorker.run(
                    instanceUrl: instance.url,
                    apiKey: instance.apiKey
                )
                let status = InstanceStatus(instanceId: instance.id, status: .succeed(systemStatus))
                appendStatus(status: status)
            } catch {
                let status = InstanceStatus(instanceId: instance.id, status: .fail)
                appendStatus(status: status)
            }
        }
    }

    private func appendStatus(status: InstanceStatus) {
        if let index = instanceStatus.firstIndex(where: { $0.instanceId == status.instanceId }) {
            instanceStatus[index] = status
        } else {
            instanceStatus.append(status)
        }
    }

    struct InstanceStatus {
        let instanceId: Int
        let status: Status

        enum Status {
            case fail
            case succeed(SystemStatus)
        }

        var system: SystemStatus? {
            guard case let .succeed(system) = status else { return nil }
            return system
        }
    }
}
