//
//  GetFilmsWebWorkingResponse.swift
//  Workers
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Foundation

struct GetFilmsWebWorkingResponse: Decodable, Sendable {
    let id: Int
    let title: String
    let originalTitle: String
    let alternateTitles: [AlternateTitles]
    let sortTitle: String
    let status: Status
    let overview: String
    let images: [Image]
    let year: Int
    let path: String

    enum Status: String, Decodable {
        case tba
        case announced
        case inCinemas
        case released
        case deleted
    }

    struct AlternateTitles: Decodable, Sendable {
        let title: String
        let cleanTitle: String?
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
