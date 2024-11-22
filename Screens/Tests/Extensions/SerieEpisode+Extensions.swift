//
//  SerieEpisode+Extensions.swift
//  Screens
//
//  Created by Maxence Mottard on 21/11/2024.
//

import Foundation
import Testing
import Workers
@testable import Screens

@Suite("SerieEpisodeExtensionsTests")
struct SerieEpisodeExtensions {
    @Test func totalEpisodes() {
        let episodes: [SerieEpisode] = [
            .preview(),
            .preview(),
            .preview(),
            .preview(),
            .preview(),
        ]
        #expect(episodes.totalEpisodes == 5)
    }

    @Test func downloadedEpisodes() {
        let episodes: [SerieEpisode] = [
            .preview(isDownloaded: false),
            .preview(isDownloaded: true),
            .preview(isDownloaded: true),
            .preview(isDownloaded: false),
            .preview(isDownloaded: true),
        ]
        #expect(episodes.downloadedEpisodes == 3)
    }

    @Test func monitoredEpisodes() {
        let episodes: [SerieEpisode] = [
            .preview(isDownloaded: true, isMonitored: false),
            .preview(isDownloaded: true, isMonitored: false),
            .preview(isDownloaded: true, isMonitored: false),
            .preview(isDownloaded: false, isMonitored: true),
            .preview(isDownloaded: false, isMonitored: true),
        ]
        #expect(episodes.monitoredEpisodes == 5)
    }

    @Test func monitoredEpisodesWithNonDiffusedEpisodes() {
        let episodes: [SerieEpisode] = [
            .preview(isDownloaded: true, isMonitored: false, diffusionDate: .today),
            .preview(isDownloaded: true, isMonitored: false, diffusionDate: .today),
            .preview(isDownloaded: false, isMonitored: true, diffusionDate: .today),
            .preview(isDownloaded: false, isMonitored: true, diffusionDate: .today.add(days: 1)),
            .preview(isDownloaded: false, isMonitored: true, diffusionDate: .today.add(days: 1)),
        ]
        #expect(episodes.monitoredEpisodes == 3)
    }

    @Test func monitoredEpisodesWithNonDiffusedEpisodes2() {
        let episodes: [SerieEpisode] = [
            .preview(isDownloaded: true, isMonitored: true, diffusionDate: .today),
            .preview(isDownloaded: true, isMonitored: true, diffusionDate: .today),
            .preview(isDownloaded: false, isMonitored: true, diffusionDate: .today),
            .preview(isDownloaded: false, isMonitored: true, diffusionDate: .today.add(days: 1)),
            .preview(isDownloaded: false, isMonitored: true, diffusionDate: .today.add(days: 1)),
        ]
        #expect(episodes.monitoredEpisodes == 3)
    }
}
