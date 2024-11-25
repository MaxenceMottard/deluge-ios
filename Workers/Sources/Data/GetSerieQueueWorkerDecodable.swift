//
//  GetSerieQueueWorkerDecodable.swift
//  Workers
//
//  Created by Maxence Mottard on 25/11/2024.
//

import Foundation

struct GetSerieQueueWorkerDecodable: Decodable {
    let id: Int
    let seriesId: Int
    let episodeId: Int
    let seasonNumber: Int
    let status: String
}
