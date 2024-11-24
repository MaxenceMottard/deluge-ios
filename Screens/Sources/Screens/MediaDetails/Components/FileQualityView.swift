//
//  FileQualityView.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI
import Workers

struct FileQualityView: View {
    let quality: Serie.Episode.File.Quality?

    var body: some View {
        if let quality {
            Text(quality.name)
                .font(.caption)
                .padding(.vertical, 2)
                .padding(.horizontal, 4)
                .background(.gray)
                .cornerRadius(5)
        }
    }
}

#Preview {
    FileQualityView(
        quality: Serie.Episode.File.Quality(
            id: UUID().hashValue,
            name: "WEBDL-1080p",
            source: "WEBDL",
            resolution: 1080
        )
    )
}
