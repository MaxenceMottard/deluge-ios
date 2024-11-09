//
//  LoginViewModel.swift
//  Deluge
//
//  Created by Maxence Mottard on 28/10/2024.
//

@preconcurrency import Workers
import Foundation
import Routing
import Utils

@Observable
@MainActor
class LoginViewModel {
    struct Dependencies {
        let checkConfigurationWebWorker: CheckConfigurationWebWorking
        let instanceWorker: InstanceWorking
        let router: Routing
    }

    private let dependencies: Dependencies

    // MARK: State

    var serverUrl: String = ""
    var apiKey: String = ""

    // MARK: Init

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    // MARK: Methods

    func login() async {
        do {
            try await dependencies.checkConfigurationWebWorker.run(instanceUrl: serverUrl, apiKey: apiKey)
            let newInstance = Instance(url: serverUrl, apiKey: apiKey)
            dependencies.instanceWorker.instances.insert(newInstance)
            dependencies.instanceWorker.selectedInstance = newInstance
            dependencies.router.dismiss()
        } catch {
            print("[DEBUG] EROR: ", error)
        }
    }
}
