//
//  SearchSerieWorkerDecodable.swift
//  Workers
//
//  Created by Maxence Mottard on 26/11/2024.
//

import Foundation

struct SearchSerieWorkerDecodable: Decodable {
    let title: String
    let sortTitle: String
    let ended: Bool
    let overview: String?
    let network: String?
    let airTime: String?
    let images: [GetMoviesWorkerDecodable.Image]
    let seasons: [Season]
    let year: Int

    struct Season: Decodable {
        let seasonNumber: Int
        let monitored: Bool
    }

    enum CodingKeys: CodingKey {
        case title
        case sortTitle
        case ended
        case overview
        case network
        case airTime
        case images
        case seasons
        case year
    }

    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.sortTitle = try container.decode(String.self, forKey: .sortTitle)
        self.ended = try container.decode(Bool.self, forKey: .ended)
        self.overview = try container.decodeIfPresent(String.self, forKey: .overview)
        self.network = try container.decodeIfPresent(String.self, forKey: .network)
        self.airTime = try container.decodeIfPresent(String.self, forKey: .airTime)
        self.images = try container.decode([GetMoviesWorkerDecodable.Image].self, forKey: .images)
        self.seasons = try container.decode([SearchSerieWorkerDecodable.Season].self, forKey: .seasons)
        self.year = try container.decode(Int.self, forKey: .year)
    }
}
