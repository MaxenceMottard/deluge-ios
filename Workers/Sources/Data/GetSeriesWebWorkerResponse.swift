//
//  GetSeriesWebWorkerResponse.swift
//  Workers
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Foundation

struct GetSeriesWebWorkerResponse: Decodable {
    let id: Int
    let title: String
    let alternateTitles: [AlternateTitles]
    let sortTitle: String
    let status: Status
    let ended: Bool
    let overview: String
    let network: String
    let airTime: String?
    let images: [Image]
    let year: Int
    let seasons: [Season]

    enum Status: String, Decodable {
        case continuing
        case ended
        case upcoming
        case deleted
    }

    struct AlternateTitles: Decodable {
        let title: String
        let seasonNumber: Int?
    }

    struct Image: Decodable {
        let coverType: Cover
        let url: String
        let remoteUrl: String

        enum Cover: String, Decodable {
            case unknown
            case poster
            case banner
            case fanart
            case screenshot
            case headshot
            case clearlogo
        }
    }

    struct Season: Decodable {
        let seasonNumber: Int
        let monitored: Bool
        let statistics: Statistics

        struct Statistics: Decodable {
            let episodeFileCount: Int
            let episodeCount: Int
            let totalEpisodeCount: Int
            let sizeOnDisk: Int
            let percentOfEpisodes: Double
        }
    }
}
