//
//  RepositoriesAssembly.swift
//  Workers
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Swinject
import Utils

public struct RepositoriesAssembly: Assembly {
    public init() {}

    public func assemble(container: Swinject.Container) {
        container.register(InstanceRepository.self) { _ in
            DefaultInstanceRepository(keychainWorker: container.resolve(KeychainWorking.self)!)
        }
        .inObjectScope(.container)
    }
}
