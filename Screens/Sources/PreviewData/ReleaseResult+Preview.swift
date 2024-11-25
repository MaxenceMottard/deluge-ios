//
//  ReleaseResult+Preview.swift
//  Screens
//
//  Created by Maxence Mottard on 25/11/2024.
//

import Foundation
import Workers

extension ReleaseResult {
    static func preview(
        title: String = "Ultimate.Collection.2024.MULTi.1080p.WEB-DL.x264-Shadow \(UUID().uuidString)",
        infoUrl: String = "https://google.com",
        downloadUrl: String = "https://google.com",
        rejected: Bool = false,
        approved: Bool = false,
        publishDate: Date? = .today.add(days: -5),
        seeders: Int = 100,
        leechers: Int = 8,
        quality: Quality = Quality(
            id: UUID().hashValue,
            name: "WEBDL-1080p",
            source: "WEBDL",
            resolution: 1080
        ),
        size: Int = 10031312462,
        ageHours: Double = 36.6,
        ageMinutes: Double = 200.98,
        indexer: String = "the pirate bay"
    ) -> ReleaseResult {
        ReleaseResult(
            title: title,
            infoUrl: infoUrl,
            downloadUrl: downloadUrl,
            rejected: rejected,
            approved: approved,
            publishDate: publishDate,
            seeders: seeders,
            leechers: leechers,
            quality: quality,
            size: size,
            ageHours: ageHours,
            ageMinutes: ageMinutes,
            indexer: indexer
        )
    }
}

extension [ReleaseResult] {
    static var preview: [ReleaseResult] {
        [
            .preview(),
            .preview(),
            .preview(),
            .preview(),
            .preview(),
            .preview(),
        ]
    }
}
