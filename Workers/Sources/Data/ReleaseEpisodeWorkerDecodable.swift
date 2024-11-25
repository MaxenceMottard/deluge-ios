//
//  ReleaseEpisodeWorkerDecodable.swift
//  Workers
//
//  Created by Maxence Mottard on 24/11/2024.
//

import Foundation

struct ReleaseEpisodeWorkerDecodable: Decodable {
    let title: String
    let infoUrl: String
    let downloadUrl: String
    let rejected: Bool
    let approved: Bool
    let publishDate: String
    let seeders: Int
    let leechers: Int
    let quality: Quality
    let size: Int
    let ageHours: Double
    let ageMinutes: Double
    let indexer: String

    struct Quality: Decodable {
        let quality: Information

        struct Information: Decodable {
            let id: Int
            let name: String
            let source: String
            let resolution: Int
        }
    }
}
