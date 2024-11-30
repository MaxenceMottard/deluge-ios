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
        // MARK: Common
        container.register(GetSystemStatusWorking.self) { _ in GetSystemStatusWorker() }

        // MARK: Sonarr
        container.register(GetSeriesWorking.self) { _ in GetSeriesWorker() }
        container.register(GetSerieWorking.self) { _ in GetSerieWorker() }
        container.register(GetEpisodesWorking.self) { _ in GetEpisodesWorker() }
        container.register(GetEpisodesFilesWorking.self) { _ in GetEpisodesFilesWorker() }
        container.register(MonitorEpisodesWorking.self) { _ in MonitorEpisodesWorker() }
        container.register(MonitorSeasonWorking.self) { _ in MonitorSeasonWorker() }
        container.register(SonarrCommandWorking.self) { _ in SonarrCommandWorker() }
        container.register(GetEpisodeReleasesWorking.self) { _ in GetEpisodeReleasesWorker() }
        container.register(GetSeasonReleasesWorking.self) { _ in GetSeasonReleasesWorker() }
        container.register(ReleaseEpisodeWorking.self) { _ in ReleaseEpisodeWorker() }
        container.register(GetSerieQueueWorking.self) { _ in GetSerieQueueWorker() }
        container.register(SearchSerieWorking.self) { _ in SearchSerieWorker() }
        container.register(GetQualityProfilesWorking.self) { _ in GetQualityProfilesWorker() }
        container.register(GetRootFoldersWorking.self) { _ in GetRootFoldersWorker() }
        container.register(AddSerieWorking.self) { _ in AddSerieWorker() }
        container.register(DeleteSerieWorking.self) { _ in DeleteSerieWorker() }

        // MARK: Radarr
        container.register(GetMoviesbWorking.self) { _ in GetMoviesWorker() }
        container.register(GetMovieReleasesWorking.self) { _ in GetMovieReleasesWorker() }
        container.register(DeleteMovieWorking.self) { _ in DeleteMovieWorker() }
        container.register(RadarrCommandWorking.self) { _ in RadarrCommandWorker() }
        container.register(SearchMovieWorking.self) { _ in SearchMovieWorker() }
    }
}
