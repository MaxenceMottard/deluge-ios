//
//  MediaDetailsSerieView.swift
//  Screens
//
//  Created by Maxence Mottard on 20/11/2024.
//

import SwiftUI
import Workers
import NukeUI
import DesignSystem

struct MediaDetailsSerieView: View {
    let viewModel: any MediaDetailsSerieViewModel

    var body: some View {
        VStack {
            ForEach(viewModel.seasons) { season in
                let episodes = viewModel.getEpisodes(of: season)
                let queueItems = viewModel.getQueueItems(of: season)

                ExpandableView {
                    HStack {
                        Group {
                            if season.isMonitored {
                                Button(action: { unmonitor(season: season) }) {
                                    Image(systemName: "bookmark.fill")
                                }
                            } else {
                                Button(action: { monitor(season: season) }) {
                                    Image(systemName: "bookmark")
                                }
                            }
                        }

                        Group {
                            if season.seasonNumber == 0 {
                                Text("mediaDetails.serie.label.specials", bundle: .module)
                            } else {
                                Text("mediaDetails.serie.label.season \(season.seasonNumber)", bundle: .module)
                            }
                        }

                        PillView(
                            value: [
                                String(season.episodeFileCount),
                                queueItems.isEmpty ? nil : "+ \(queueItems.count)",
                                "/",
                                String(season.episodeCount)
                            ]
                            .compactMap({ $0 })
                            .joined(separator: " "),
                            status: viewModel.getStatus(of: season).toCounterStatus()
                        )

                        FileSizeView(size: season.sizeOnDisk)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        ActionsMenu(actions: [
                            .automaticSearch { await viewModel.automaticSearch(of: season) },
                            .interactiveSearch { viewModel.interactiveSearch(of: season) },
                        ])
                    }
                } content: {
                    VStack {
                        ForEach(episodes, id: \.id) { episode in
                            MediaDetailsSerieEpisodeView(
                                episode: episode,
                                file: viewModel.getEpisodeFile(of: episode),
                                queueItem: viewModel.getQueueItem(of: episode),
                                monitor: { await viewModel.monitor(episodes: [episode]) },
                                unmonitor: { await viewModel.unmonitor(episodes: [episode]) },
                                automaticSearch: { await viewModel.automaticSearch(of: episode) },
                                interactiveSearch: { viewModel.interactiveSearch(of: episode) }
                            )
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
        .task { await viewModel.fetchData() }
    }

    private func monitor(season: Serie.Season) {
        Task { await viewModel.monitor(season: season) }
    }

    private func unmonitor(season: Serie.Season) {
        Task { await viewModel.unmonitor(season: season) }
    }
}

#Preview {
    let viewModel: MediaDetailsSerieViewModel = {
        let viewModel = MockMediaDetailsSerieViewModel()
        viewModel.serie = .preview()
        viewModel.seasons = viewModel.serie.seasons
        viewModel.getEpisodesOfSerieSeasonSerieEpisodeReturnValue = .preview.prefix(6).map({ $0 })
        viewModel.getStatusOfSerieSeasonSeasonStatusReturnValue = .missingNonMonitored
        viewModel.getEpisodeFileOfSerieEpisodeSerieEpisodeFileReturnValue = .preview()
        viewModel.getQueueItemOfSerieEpisodeSerieQueueItemReturnValue = nil
        viewModel.getQueueItemsOfSeasonSerieSeasonSerieQueueItemReturnValue = []

        return viewModel
    }()

    ScrollView {
        MediaDetailsSerieView(viewModel: viewModel)
    }
}

private extension SeasonStatus {
    func toCounterStatus() -> PillView.Status {
        switch self {
        case .completed: .success
        case .missingMonitored: .error
        case .missingNonMonitored: .warning
        case .queued: .queued
        }
    }
}
