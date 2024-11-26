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
    let viewModel: any MediaDetailsSerieViewModeling

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
                    }
                } content: {
                    MediaDetailsSerieEpisodesView(
                        episodes: episodes,
                        getEpisodeFile: viewModel.getEpisodeFile(of:),
                        getEpisodeQueueItem: viewModel.getQueueItem(of:),
                        monitor: { await viewModel.monitor(episodes: [$0]) },
                        unmonitor: { await viewModel.unmonitor(episodes: [$0]) },
                        search: viewModel.search(episode:),
                        release: viewModel.getReleases(of:)
                    )
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
    let viewModel: MediaDetailsSerieViewModeling = {
        let viewModel = MediaDetailsSerieViewModelingMock()
        viewModel.serie = .preview()
        viewModel.seasons = viewModel.serie.seasons
        viewModel.getEpisodesOfSerieSeasonSerieEpisodeReturnValue = .preview.prefix(6).map({ $0 })
        viewModel.getStatusOfSerieSeasonSeasonStatusReturnValue = .missingNonMonitored
        viewModel.getEpisodeFileOfSerieEpisodeSerieEpisodeFileReturnValue = .preview()

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
