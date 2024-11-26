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
    let getEpisodeQueueItem: (Serie.Episode) -> Serie.QueueItem?
    let monitor: (Serie.Episode) async -> Void
    let unmonitor: (Serie.Episode) async -> Void
    let search: (Serie.Episode) async -> Void
    let release: (Serie.Episode) async -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(episodes, id: \.id) { episode in
                let file = getEpisodeFile(episode)
                let queueItem = getEpisodeQueueItem(episode)

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
                        Text("mediaDetails.serie.label.episodeName \(episode.episodeNumber) \(episode.title)")
                            .multilineTextAlignment(.leading)
                            .lineLimit(2)

                        HStack {
                            if file != nil {
                                Image(systemName: "checkmark.icloud")
                                    .foregroundStyle(.green)
                            }

                            if queueItem != nil {
                                Image(systemName: "icloud.and.arrow.down")
                                    .foregroundStyle(.purple)
                            }

                            if let diffusionData = episode.diffusionDate {
                                Text(diffusionData, style: .date)
                                    .foregroundStyle(.gray)
                            }
                        }
                        .font(.caption)

                        FileQualityView(quality: file?.quality.name)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)

                    ActionsMenu(actions: [
                        .search { await search(episode) },
                        .release { await release(episode) },
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
        getEpisodeQueueItem: { _ in
            nil
        },
        monitor: { _ in },
        unmonitor: { _ in },
        search: { _ in },
        release: { _ in }
    )
}


