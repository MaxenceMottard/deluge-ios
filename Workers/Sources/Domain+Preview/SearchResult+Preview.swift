//
//  SearchResult+Preview.swift
//  Workers
//
//  Created by Maxence Mottard on 26/11/2024.
//

import Foundation

public extension SearchResult {
    static func preview(
        title: String = "Breaking Bad",
        description: String? = "Breaking Bad is an American television series created by Vince Gilligan that premiered in 2008.",
        year: Int = 2008,
        poster: String? = "https://media.themoviedb.org/t/p/w300_and_h450_bestv2/abf8tHznhSvl9BAElD2cQeRr7do.jpg",
        banner: String? = "https://image.tmdb.org/t/p/original/1yeVJox3rjo2jBKrrihIMj7uoS9.jpg",
        data: [String: any Sendable]? = [:]
    ) -> SearchResult {
        SearchResult(
            title: title,
            description: description,
            year: year,
            poster: poster,
            banner: banner,
            data: data
        )
    }
}

public extension [SearchResult] {
    static var preview: [SearchResult] {
        [.preview(), .preview(), .preview(), .preview()]
    }
}
