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
    let viewModel: MediaDetailsSerieViewModel

    init(viewModel: MediaDetailsSerieViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        VStack {
            ForEach(viewModel.seasons, id: \.key) { (seasonNumber, episodes) in
                ExpandableView {
                    HStack {
                        Text(seasonNumber == 0 ? "Épisodes spéciaux" : "Season \(seasonNumber)")
                        seasonCounter(episodes: episodes)
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
                if episode.monitored {
                    unmonitorButton(episode: episode)
                } else {
                    monitorButton(episode: episode)
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

    private func monitorButton(episode: SerieEpisode) -> some View {
        Button(action: {
            Task { await viewModel.monitor(episode: episode) }
        }) {
            Image(systemName: "bookmark")
        }
    }

    private func unmonitorButton(episode: SerieEpisode) -> some View {
        Button(action: {
            Task { await viewModel.unmonitor(episode: episode) }
        }) {
            Image(systemName: "bookmark.fill")
        }
    }

    private func seasonCounter(episodes: [SerieEpisode]) -> some View {
        let color: Color = switch episodes.status {
        case .completed: .green
        case .missingMonitored: .red
        case .missingNonMonitored: .orange
        }

        return Text("\(episodes.downloadedEpisodes) / \(episodes.monitoredEpisodes)")
            .padding(.vertical, 3)
            .padding(.horizontal, 6)
            .background(color)
            .cornerRadius(8)
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
    let getSerieEpisodeWorker: GetSerieEpisodeWebWorking = {
        let worker = GetSerieEpisodeWebWorkingMock()
        worker.runIdReturnValue = .preview

        return worker
    }()

    VStack {
        MediaDetailsSerieView(
            viewModel: MediaDetailsSerieViewModel(
                serie: .preview(),
                dependencies: MediaDetailsSerieViewModel.Dependencies(
                    getSerieEpisodeWorker: getSerieEpisodeWorker,
                    monitorSerieEpisodeWorking: MonitorSerieEpisodeWebWorkingMock()
                )
            )
        )

        Spacer()
    }
}


