//
//  GetSeriesWebWorkingResponse.swift
//  Workers
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Foundation

struct GetSeriesWebWorkingResponse: Decodable, Sendable {
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

    enum Status: String, Decodable {
        case continuing
        case ended
        case upcoming
        case deleted
    }

    struct AlternateTitles: Decodable, Sendable {
        let title: String
        let seasonNumber: Int?
    }

    struct Image: Decodable, Sendable {
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
}
