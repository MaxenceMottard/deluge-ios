//
//  MediaDetailsSerieView.swift
//  Screens
//
//  Created by Maxence Mottard on 20/11/2024.
//

import SwiftUI
import Workers
import NukeUI

struct MediaDetailsSerieView: View {
    let viewModel: any MediaDetailsSerieViewModeling

    var body: some View {
        VStack {
            ForEach(viewModel.seasons, id: \.key) { (seasonNumber, episodes) in
                let season = viewModel.getSeason(with: seasonNumber)

                ExpandableView {
                    HStack {
                        Text(seasonNumber == 0 ? "Épisodes spéciaux" : "Season \(seasonNumber)")

                        seasonCounter(season: season)

                        if let season, season.sizeOnDisk > 0 {
                            let size = season.sizeOnDisk.toGigabytes().toString(numberOfDecimals: 1)
                            Text("\(size) GB")
                                .foregroundStyle(.gray)
                                .font(.callout)
                        }
                    }
                } content: {
                    listEpisodes(episodes: episodes)
                }
            }
        }
        .task { await viewModel.fetchEpisodes() }
    }

    private func listEpisodes(episodes: [SerieEpisode]) -> some View {
        ForEach(episodes, id: \.id) { episode in
            HStack(alignment: .top) {
                if episode.isMonitored {
                    unmonitorButton(episodes: [episode])
                } else {
                    monitorButton(episodes: [episode])
                }

                Text("\(episode.episodeNumber)")

                VStack(alignment: .leading, spacing: 0) {
                    Text(episode.title)
                        .multilineTextAlignment(.leading)

                    if let diffusionData = episode.diffusionDate {
                        Text(diffusionData, style: .date)
                            .font(.caption)
                            .foregroundStyle(.gray)
                    }
                }
            }
        }
    }

    private func monitorButton(episodes: [SerieEpisode]) -> some View {
        Button(action: {
            Task { await viewModel.monitor(episodes: episodes) }
        }) {
            Image(systemName: "bookmark")
        }
    }

    private func unmonitorButton(episodes: [SerieEpisode]) -> some View {
        Button(action: {
            Task { await viewModel.unmonitor(episodes: episodes) }
        }) {
            Image(systemName: "bookmark.fill")
        }
    }

    @ViewBuilder private func seasonCounter(season: Serie.Season?) -> some View {
        if let season {
            let status = viewModel.getStatus(of: season)
            let color: Color = switch status {
            case .completed: .green
            case .missingMonitored: .red
            case .missingNonMonitored: .orange
            }

            Text("\(season.episodeFileCount) / \(season.episodeCount)")
                .padding(.vertical, 3)
                .padding(.horizontal, 6)
                .background(color)
                .cornerRadius(8)
        }
    }
}

struct ExpandableView<H: View, C: View>: View {
    @State private var isExpanded: Bool = false

    let header: () -> H
    let content: () -> C

    var body: some View {
        ContainerView {
            VStack(spacing: 0) {
                HStack {
                    header()
                        .frame(maxWidth: .infinity, alignment: .leading)
                    Image(systemName: "chevron.down")
                        .rotationEffect(isExpanded ? .degrees(180) : .degrees(0))
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    withAnimation {
                        isExpanded.toggle()
                    }
                }

                if isExpanded {
                    content()
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(.top)
                }
            }
            .padding()
        }
    }
}

#Preview {
    let viewModel: MediaDetailsSerieViewModeling = {
        let viewModel = MediaDetailsSerieViewModelingMock()
        viewModel.serie = .preview()
        viewModel.getSeasonWithIntSerieSeasonReturnValue = viewModel.serie.seasons.randomElement()
        viewModel.getStatusOfSeasonSerieSeasonSeasonStatusReturnValue = SeasonStatus.allCases.randomElement()
        viewModel.seasons = Dictionary(grouping: [SerieEpisode].preview, by: \.seasonNumber).map({ $0 })

        return viewModel
    }()

    MediaDetailsSerieView(viewModel: viewModel)
}


