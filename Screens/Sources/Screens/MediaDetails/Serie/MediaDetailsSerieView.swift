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

                ExpandableView {
                    HStack {
                        Group {
                            if season.isMonitored {
                                unmonitorButton(action: {
                                    await viewModel.unmonitor(season: season)
                                })
                            } else {
                                monitorButton(action: {
                                    await viewModel.monitor(season: season)
                                })
                            }
                        }

                        Text(season.seasonNumber == 0 ? "Épisodes spéciaux" : "Season \(season.seasonNumber)")

                        seasonCounter(season: season)

                        let size = season.sizeOnDisk.toGigabytes().toString(numberOfDecimals: 1)
                        Text("\(size) GB")
                            .foregroundStyle(.gray)
                            .font(.callout)
                            .hidden(season.sizeOnDisk < 1)
                    }
                } content: {
                    listEpisodes(episodes: episodes)
                }
            }
        }
        .task { await viewModel.fetchData() }
    }

    private func listEpisodes(episodes: [Serie.Episode]) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(episodes, id: \.id) { episode in
                let file = viewModel.getEpisodeFile(of: episode)

                HStack(alignment: .top) {
                    if episode.isMonitored {
                        unmonitorButton(action: {
                            await viewModel.unmonitor(episodes: [episode])
                        })
                    } else {
                        monitorButton(action: {
                            await viewModel.monitor(episodes: [episode])
                        })
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

                        if let file {
                            Text(file.quality.name)
                                .font(.caption)
                                .padding(.vertical, 2)
                                .padding(.horizontal, 4)
                                .background(.gray)
                                .cornerRadius(5)
                        }
                    }
                }
            }
        }
    }

    private func monitorButton(action: @escaping () async -> Void) -> some View {
        Button(action: {
            Task {
                await action()
            }
        }) {
            Image(systemName: "bookmark")
        }
    }

    private func unmonitorButton(action: @escaping () async -> Void) -> some View {
        Button(action: {
            Task {
                await action()
            }
        }) {
            Image(systemName: "bookmark.fill")
        }
    }

    private func seasonCounter(season: Serie.Season) -> some View {
        let status = viewModel.getStatus(of: season)

        let color: Color = switch status {
        case .completed: .green
        case .missingMonitored: .red
        case .missingNonMonitored: .orange
        }

        return Text("\(season.episodeFileCount) / \(season.episodeCount)")
            .padding(.vertical, 3)
            .padding(.horizontal, 6)
            .background(color)
            .cornerRadius(8)
    }
}

#Preview {
    let viewModel: MediaDetailsSerieViewModeling = {
        let viewModel = MediaDetailsSerieViewModelingMock()
        viewModel.serie = .preview()
        viewModel.getSeasonWithIntSerieSeasonReturnValue = viewModel.serie.seasons.randomElement()
        viewModel.getStatusOfSeasonSerieSeasonSeasonStatusReturnValue = SeasonStatus.allCases.randomElement()
        viewModel.getSeasonWithIntSerieSeasonReturnValue = viewModel.serie.seasons.randomElement()

        return viewModel
    }()

    MediaDetailsSerieView(viewModel: viewModel)
}


