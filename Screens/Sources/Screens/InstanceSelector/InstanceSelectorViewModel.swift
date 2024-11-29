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

@MainActor
// sourcery: AutoMockable
protocol InstanceSelectorViewModel {
    var instances: [Instance] { get }
    var selectedInstance: Instance? { get }

    func addInstance()
    func remove(instance: Instance)
    func status(for instance: Instance) -> InstanceStatus?
    func fetchInstanceSatus() async
    func select(instance: Instance)
}

@Observable
@MainActor
class DefaultInstanceSelectorViewModel: InstanceSelectorViewModel {
    struct Dependencies {
        let instanceRepository: InstanceRepository
        let tapticEngineWorker: TapticEngineWorking
        let systemStatusWebWorker: GetSystemStatusWorking
        let router: Routing
    }

    private let dependencies: Dependencies

    // MARK: State
    var instances: [Instance] {
        get { dependencies.instanceRepository.instances.map({ $0 }) }
        set { dependencies.instanceRepository.instances = Set<Instance>(newValue) }
    }

    var selectedInstance: Instance? {
        get { dependencies.instanceRepository.selectedInstance }
        set { dependencies.instanceRepository.selectedInstance = newValue }
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
        dependencies.instanceRepository.remove(instance: instance)
    }

    func status(for instance: Instance) -> InstanceStatus? {
        instanceStatus.first(where: { $0.instanceId == instance.id })
    }

    func select(instance: Instance) {
        selectedInstance = instance
        dependencies.tapticEngineWorker.triggerSelectionChanged()
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
}
