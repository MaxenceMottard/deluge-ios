//
//  WebWorkersAssembly.swift
//  Workers
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Swinject

public struct WebWorkersAssembly: Assembly {
    public init() {}

    public func assemble(container: Swinject.Container) {
        container.register(SystemStatusWebWorking.self) { _ in SystemStatusWebWorker() }
        container.register(GetSeriesWebWorking.self) { _ in GetSeriesWebWorker() }
        container.register(GetMoviesWebWorking.self) { _ in GetMoviesWebWorker() }
    }
}
