//
//  RepositoriesAssembly.swift
//  Workers
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Swinject
import Utils
import Workers

public struct RepositoriesAssembly: Assembly {
    public init() {}

    public func assemble(container: Swinject.Container) {
        container.register(InstanceRepository.self) { _ in
            DefaultInstanceRepository(keychainWorker: container.resolve(KeychainWorking.self)!)
        }
        .inObjectScope(.container)

        container.register(GlobalDataRepository.self) { _ in
            DefaultGlobalDataRepository(
                dependencies: DefaultGlobalDataRepository.Dependencies(
                    getQualityProfilesWorker: Dependency.resolve(GetQualityProfilesWorking.self)!,
                    getRootFoldersWorker: Dependency.resolve(GetRootFoldersWorking.self)!
                )
            )
        }
        .inObjectScope(.container)
    }
}
