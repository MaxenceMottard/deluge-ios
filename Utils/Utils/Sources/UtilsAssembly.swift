//
//  UtilsAssembly.swift
//  Utils
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Swinject

public struct UtilsAssembly: Assembly {
    public init() {}

    public func assemble(container: Container) {
        container.register(KeychainWorking.self) { _ in
            KeychainWorker()
        }

        container.register(ImageCacheWorking.self) { _ in
            ImageCacheWorker()
        }

        container.register(InstanceWorking.self) { _ in
            InstanceWorker(keychainWorker: container.resolve(KeychainWorking.self)!)
        }
        .inObjectScope(.container)
    }
}

