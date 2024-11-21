//
//  SerieEpisode+Preview.swift
//  Screens
//
//  Created by Maxence Mottard on 10/11/2024.
//

import Foundation
import Workers

extension SerieEpisode {
    static func preview(
        id: Int = UUID().hashValue,
        title: String = "The beginning",
        serieId: Int = 1,
        episodeFileId: Int = UUID().hashValue,
        seasonNumber: Int = 1,
        episodeNumber: Int = 3,
        hasFile: Bool = false,
        monitored: Bool = false,
        diffusionDate: Date? = Date()
    ) -> SerieEpisode {
        return SerieEpisode(
            id: id,
            title: title,
            serieId: serieId,
            episodeFileId: episodeFileId,
            seasonNumber: seasonNumber,
            episodeNumber: episodeNumber,
            hasFile: hasFile,
            monitored: monitored,
            diffusionDate: diffusionDate
        )
    }
}

extension [SerieEpisode] {
    static var preview: [SerieEpisode] {
        [
            .preview(title: "omnis iste natus error sit voluptatem", seasonNumber: 1, episodeNumber: 1, hasFile: false, monitored: true),
            .preview(title: "Sed ut perspiciatis unde", seasonNumber: 1, episodeNumber: 2, hasFile: false, monitored: true),
            .preview(title: "laudantium, totam rem aperiam", seasonNumber: 1, episodeNumber: 3, hasFile: false, monitored: true),
            .preview(title: "eaque ipsa", seasonNumber: 1, episodeNumber: 4, hasFile: false, monitored: true),
            .preview(title: "quae ab illo inventore veritatis et", seasonNumber: 1, episodeNumber: 5, hasFile: false, monitored: true),
            .preview(title: "quasi architecto beatae vitae dicta sunt explicabo", seasonNumber: 1, episodeNumber: 6, hasFile: false, monitored: true),

            .preview(title: "nemo enim ipsam voluptatem", seasonNumber: 3, episodeNumber: 1, hasFile: true, monitored: false),
            .preview(title: "quia voluptas sit aspernatur", seasonNumber: 3, episodeNumber: 2, hasFile: true, monitored: false),
            .preview(title: "aut odit aut fugit, sed", seasonNumber: 3, episodeNumber: 3, hasFile: true, monitored: false),
            .preview(title: "quia consequuntur magni dolores eos", seasonNumber: 3, episodeNumber: 4, hasFile: true, monitored: false),

            .preview(title: "qui ratione", seasonNumber: 2, episodeNumber: 1, hasFile: true, monitored: false),
            .preview(title: "voluptatem sequi nesciunt", seasonNumber: 2, episodeNumber: 2, hasFile: true, monitored: false),
            .preview(title: "neque porro quisquam est, qui dolorem", seasonNumber: 2, episodeNumber: 3, hasFile: true, monitored: false),
            .preview(title: "ipsum quia dolor sit amet", seasonNumber: 2, episodeNumber: 4, hasFile: true, monitored: false),
            .preview(
                title: "consectetur, adipisci velit, sed",
                seasonNumber: 2,
                episodeNumber: 5,
                hasFile: false,
                monitored: true,
                diffusionDate: .today.add(days: 1)
            ),
            .preview(
                title: "quia non numquam eius modi tempora",
                seasonNumber: 2,
                episodeNumber: 6,
                hasFile: false,
                monitored: true,
                diffusionDate: .today.add(days: 1)
            ),
            .preview(
                title: "magnam",
                seasonNumber: 2,
                episodeNumber: 7,
                hasFile: false,
                monitored: true,
                diffusionDate: .today.add(days: 1)
            ),
            .preview(
                title: "incidunt ut labore et dolore",
                seasonNumber: 2,
                episodeNumber: 8,
                hasFile: false,
                monitored: true,
                diffusionDate: .today.add(days: 1)
            ),
        ]
    }
}
