//
//  NewInstanceViewModel.swift
//  Deluge
//
//  Created by Maxence Mottard on 28/10/2024.
//

@preconcurrency import Workers
import Foundation
import Routing
import Utils

@MainActor
// sourcery: AutoMockable
protocol NewInstanceViewModeling {
    var name: String { get set }
    var url: String { get set }
    var apiKey: String { get set }
    var type: Instance.InstanceType { get set }
    var isFormValid: Bool { get }

    func login() async
}

@Observable
@MainActor
class NewInstanceViewModel: NewInstanceViewModeling {
    struct Dependencies {
        let checkConfigurationWebWorker: SystemStatusWebWorking
        let instanceWorker: InstanceWorking
        let tapticEngineWorker: TapticEngineWorking
        let router: Routing
    }

    private let dependencies: Dependencies

    // MARK: State

    var name: String = ""
    var url: String = ""
    var apiKey: String = ""
    var type: Instance.InstanceType = .sonarr

    var isFormValid: Bool {
        !name.isEmpty && !url.isEmpty && !apiKey.isEmpty
    }

    // MARK: Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: Methods

    func login() async {
        do {
            guard isFormValid else { return }

            _ = try await dependencies.checkConfigurationWebWorker.run(instanceUrl: url, apiKey: apiKey)
            dependencies.tapticEngineWorker.triggerNotification(type: .success)
            let newInstance = Instance(type: type, name: name, url: url, apiKey: apiKey)
            dependencies.instanceWorker.instances.insert(newInstance)
            dependencies.instanceWorker.selectedInstance = newInstance
            dependencies.router.dismiss()
        } catch {
            dependencies.tapticEngineWorker.triggerNotification(type: .error)
        }
    }
}
