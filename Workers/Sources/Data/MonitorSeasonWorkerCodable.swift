//
//  MonitorSeasonWorkerCodable.swift
//  Workers
//
//  Created by Maxence Mottard on 22/11/2024.
//

import Foundation

struct MonitorSeasonWorkerCodable: Codable {
    let title: String?
    let alternateTitles: [AlternateTitle]?
    let sortTitle: String?
    let status: String?
    let ended: Bool?
    let overview: String?
    let network: String?
    let airTime: String?
    let images: [Image]?
    let originalLanguage: OriginalLanguage?
    var seasons: [Season]
    let year: Int?
    let path: String?
    let qualityProfileId: Int?
    let seasonFolder: Bool?
    let monitored: Bool?
    let monitorNewItems: String?
    let useSceneNumbering: Bool?
    let runtime: Int?
    let tvdbId: Int?
    let tvRageId: Int?
    let tvMazeId: Int?
    let tmdbId: Int?
    let firstAired: String?
    let lastAired: String?
    let seriesType: String?
    let cleanTitle: String?
    let imdbId: String?
    let titleSlug: String?
    let rootFolderPath: String?
    let certification: String?
    let genres: [String]?
    let tags: [Int]?
    let added: String?
    let ratings: Ratings?
    let statistics: Statistics?
    let languageProfileId: Int?
    let id: Int?
    let previousAiring: String?
    let nextAiring: String?

    struct AlternateTitle: Codable {
        let title: String?
        let seasonNumber: Int?
        let comment: String?
        let sceneSeasonNumber: Int?
        let sceneOrigin: String?
    }

    struct Image: Codable {
        let coverType: String?
        let url: String?
        let remoteURL: String?
    }

    struct OriginalLanguage: Codable {
        let id: Int?
        let name: String?
    }

    struct Ratings: Codable {
        let votes: Int?
        let value: Double?
    }

    struct Season: Codable {
        let seasonNumber: Int
        var monitored: Bool?
        let statistics: Statistics?
    }

    struct Statistics: Codable {
        let episodeFileCount: Int?
        let episodeCount: Int?
        let totalEpisodeCount: Int?
        let sizeOnDisk: Int?
        let releaseGroups: [String]?
        let percentOfEpisodes: Double?
        let previousAiring: String?
        let nextAiring: String?
        let seasonCount: Int?
    }
}
