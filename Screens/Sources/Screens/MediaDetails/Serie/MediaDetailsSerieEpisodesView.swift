//
//  MediaDetailsSerieEpisodesView.swift
//  Screens
//
//  Created by Maxence Mottard on 20/11/2024.
//

import SwiftUI
import Workers
import NukeUI
import DesignSystem

struct MediaDetailsSerieEpisodesView: View {
    let episodes: [Serie.Episode]
    let getEpisodeFile: (Serie.Episode) -> Serie.Episode.File?
    let monitor: (Serie.Episode) async -> Void
    let unmonitor: (Serie.Episode) async -> Void
    let search: (Serie.Episode) async -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(episodes, id: \.id) { episode in
                let file = getEpisodeFile(episode)

                HStack(alignment: .top) {
                    if episode.isMonitored {
                        Button(action: { unmonitor(episode: episode) }) {
                            Image(systemName: "bookmark.fill")
                        }
                    } else {
                        Button(action: { monitor(episode: episode) }) {
                            Image(systemName: "bookmark")
                        }
                    }

                    VStack(alignment: .leading) {
                        Group {
                            Text("\(episode.episodeNumber) - ") + Text(episode.title)
                        }
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)

                        if let diffusionData = episode.diffusionDate {
                            Text(diffusionData, style: .date)
                                .font(.caption)
                                .foregroundStyle(.gray)
                        }

                        FileQualityView(quality: file?.quality)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    ActionsMenu(actions: [
                        .search(action: { await search(episode) })
                    ])
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private func monitor(episode: Serie.Episode) {
        Task { await monitor(episode) }
    }

    private func unmonitor(episode: Serie.Episode) {
        Task { await unmonitor(episode) }
    }
}

#Preview {
    MediaDetailsSerieEpisodesView(
        episodes: .preview.prefix(6).map({ $0 }),
        getEpisodeFile: { _ in
            let values = [Serie.Episode.File.preview(), nil]
            return values.randomElement()!
        },
        monitor: { _ in },
        unmonitor: { _ in },
        search: { _ in }
    )
}


