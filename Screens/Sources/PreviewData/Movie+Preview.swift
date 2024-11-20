//
//  Movie+Preview.swift
//  Screens
//
//  Created by Maxence Mottard on 10/11/2024.
//

import Foundation
import Workers

extension Movie {
    static func preview(
        title: String = "First film name",
        description: String = "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth",
        year: Int = 2021,
        status: Movie.Status = .released,
        poster: String = "https://image.tmdb.org/t/p/original/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg",
        banner: String = ""
    ) -> Movie {
        return Movie(
            id: UUID().hashValue,
            title: title,
            description: description,
            year: year,
            status: status,
            poster: poster,
            banner: banner
        )
    }
}

extension [Movie] {
    static var preview: [Movie] {
        [
            .preview(
                title: "Dune",
                year: 2023,
                poster: "https://image.tmdb.org/t/p/original/1pdfLvkbY9ohJlCjQH2CZjjYVvJ.jpg"
            ),
            .preview(
                title: "One Piece",
                year: 1999,
                poster: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/cMD9Ygz11zjJzAovURpO75Qg7rT.jpg"
            ),
            .preview(
                title: "Deadpool & Wolverine",
                year: 2024,
                poster: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/8cdWjvZQUExUUTzyp4t6EDMubfO.jpg"
            ),
            .preview(
                title: "Bleach",
                year: 2004,
                poster: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/2EewmxXe72ogD0EaWM8gqa0ccIw.jpg"
            ),
            .preview(
                title: "Lioness",
                year: 2023,
                poster: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/ajaXSmdAlYYhnvx1EIsvpfN949y.jpg"
            ),
            .preview(
                title: "Desperate Housewives",
                year: 2004,
                poster: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/sywYmV9c9Vj2U7ocqNyfDt2pz3r.jpg"
            ),

            .preview(
                title: "Dragon Ball Z",
                year: 1989,
                poster: "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/6VKOfL6ihwTiB5Vibq6QTfzhxA6.jpg"
            ),
        ]
    }
}
