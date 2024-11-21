//
//  GetSerieEpisodeWebWorkerResponse.swift
//  Workers
//
//  Created by Maxence Mottard on 21/11/2024.
//

import Foundation

struct GetSerieEpisodeWebWorkerResponse: Decodable {
    let id: Int
    let seriesId: Int
    let episodeFileId: Int
    let seasonNumber: Int
    let episodeNumber: Int
    let title: String
    let airDate: String?
    let airDateUtc: String?
    let runtime: Int
    let overview: String?
    let hasFile: Bool
    let monitored: Bool
    let unverifiedSceneNumbering: Bool
}
