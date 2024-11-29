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

struct MediaDetailsSerieEpisodeView: View {
    let episode: Serie.Episode
    let file: Serie.Episode.File?
    let queueItem: Serie.QueueItem?
    let monitor: () async -> Void
    let unmonitor: () async -> Void
    let automaticSearch: () async -> Void
    let interactiveSearch: () async -> Void

    var body: some View {
        HStack(alignment: .top) {
            if episode.isMonitored {
                Button {
                    Task { await unmonitor() }
                } label: {
                    Image(systemName: "bookmark.fill")
                }
            } else {
                Button {
                    Task { await monitor() }
                } label: {
                    Image(systemName: "bookmark")
                }
            }

            VStack(alignment: .leading) {
                Text("mediaDetails.serie.label.episodeName \(episode.episodeNumber) \(episode.title)", bundle: .module)
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
                .automaticSearch { await automaticSearch() },
                .interactiveSearch { await interactiveSearch() },
            ])
        }
    }
}

#Preview {
    MediaDetailsSerieEpisodeView(
        episode: .preview(),
        file: .preview(),
        queueItem: nil,
        monitor: {},
        unmonitor: {},
        automaticSearch: {},
        interactiveSearch: {}
    )

    MediaDetailsSerieEpisodeView(
        episode: .preview(),
        file: nil,
        queueItem: nil,
        monitor: {},
        unmonitor: {},
        automaticSearch: {},
        interactiveSearch: {}
    )
}


