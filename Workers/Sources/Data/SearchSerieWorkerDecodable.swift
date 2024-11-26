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
}
