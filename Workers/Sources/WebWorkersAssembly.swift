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
        container.register(GetSystemStatusWorking.self) { _ in GetSystemStatusWorker() }
        container.register(GetSeriesWorking.self) { _ in GetSeriesWorker() }
        container.register(GetSerieWorking.self) { _ in GetSerieWorker() }
        container.register(GetEpisodesWorking.self) { _ in GetEpisodesWorker() }
        container.register(MonitorEpisodesWorking.self) { _ in MonitorEpisodesWorker() }
        container.register(MonitorSeasonWorking.self) { _ in MonitorSeasonWorker() }
        container.register(GetMoviesbWorking.self) { _ in GetMoviesWorker() }
    }
}
