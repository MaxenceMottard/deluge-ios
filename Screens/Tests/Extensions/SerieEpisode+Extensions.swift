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
            .preview(hasFile: false),
            .preview(hasFile: true),
            .preview(hasFile: true),
            .preview(hasFile: false),
            .preview(hasFile: true),
        ]
        #expect(episodes.downloadedEpisodes == 3)
    }

    @Test func monitedEpisodes() {
        let episodes: [SerieEpisode] = [
            .preview(hasFile: true, monitored: false),
            .preview(hasFile: true, monitored: false),
            .preview(hasFile: true, monitored: false),
            .preview(hasFile: false, monitored: true),
            .preview(hasFile: false, monitored: true),
        ]
        #expect(episodes.monitoredEpisodes == 5)
    }

    @Test func monitedEpisodesWithNonDiffusedEpisodes() {
        let episodes: [SerieEpisode] = [
            .preview(hasFile: true, monitored: false, diffusionDate: .today),
            .preview(hasFile: true, monitored: false, diffusionDate: .today),
            .preview(hasFile: false, monitored: true, diffusionDate: .today),
            .preview(hasFile: false, monitored: true, diffusionDate: .today.add(days: 1)),
            .preview(hasFile: false, monitored: true, diffusionDate: .today.add(days: 1)),
        ]
        #expect(episodes.monitoredEpisodes == 3)
    }

    @Test func monitedEpisodesWithNonDiffusedEpisodes2() {
        let episodes: [SerieEpisode] = [
            .preview(hasFile: true, monitored: true, diffusionDate: .today),
            .preview(hasFile: true, monitored: true, diffusionDate: .today),
            .preview(hasFile: false, monitored: true, diffusionDate: .today),
            .preview(hasFile: false, monitored: true, diffusionDate: .today.add(days: 1)),
            .preview(hasFile: false, monitored: true, diffusionDate: .today.add(days: 1)),
        ]
        #expect(episodes.monitoredEpisodes == 3)
    }
}
