//
//  MediaDetailsView.swift
//  Screens
//
//  Created by Maxence Mottard on 10/11/2024.
//

import SwiftUI
import Routing
import NukeUI
import Workers
import DesignSystem

struct MediaDetailsView: View {
    @State var viewModel: any MediaDetailsViewModel

    var body: some View {
        ScrollView {
            VStack {
                Header(media: viewModel.media)

                HStack(alignment: .top) {
                    ActionsMenu(actions: [])
                        .hidden()

                    Text(viewModel.media.title)
                        .font(.title2)
                        .multilineTextAlignment(.center)

                    ActionsMenu(actions: [
                        .refresh { await viewModel.refreshAction() },
                        .automaticSearch { await viewModel.automaticSearchAction() },
                        .interactiveSearch(isHidden: viewModel.media is Serie) {
                            viewModel.interactiveSearchAction()
                        },
                        .remove { viewModel.deleteAction() },
                    ])
                    .padding(.vertical, 5)
                }

                Text(String(viewModel.media.year))
                    .font(.subheadline)
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
            }

            VStack {
                if let media = viewModel.media as? Workers.Serie {
                    MediaDetailsSerieView(viewModel: viewModel.getSerieViewModel(media))
                }

                if let media = viewModel.media as? Workers.Movie {
                    MediaDetailsMovieView(viewModel: viewModel.getMovieViewModel(media))
                }
            }
            .padding()
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

#Preview("Serie") {
    let viewModel: any MediaDetailsViewModel = {
        let viewModel = MockMediaDetailsViewModel()
        viewModel.media = Serie.preview()
        viewModel.getSerieViewModel = { _ in
            let viewModel = MockMediaDetailsSerieViewModel()
            viewModel.serie = .preview()
            viewModel.seasons = viewModel.serie.seasons
            viewModel.getEpisodesOfSerieSeasonSerieEpisodeReturnValue = .preview.prefix(6).map({ $0 })
            viewModel.getStatusOfSerieSeasonSeasonStatusReturnValue = .missingNonMonitored
            viewModel.getEpisodeFileOfSerieEpisodeSerieEpisodeFileReturnValue = .preview()
            viewModel.getQueueItemOfSerieEpisodeSerieQueueItemReturnValue = nil
            viewModel.getQueueItemsOfSeasonSerieSeasonSerieQueueItemReturnValue = []

            return viewModel
        }

        return viewModel
    }()

    MediaDetailsView(viewModel: viewModel)
}

#Preview("Movie") {
    let viewModel: any MediaDetailsViewModel = {
        let viewModel = MockMediaDetailsViewModel()
        viewModel.media = Movie.preview()
        viewModel.getMovieViewModel = { _ in
            let viewModel = MockMediaDetailsMovieViewModel()

            return viewModel
        }

        return viewModel
    }()

    MediaDetailsView(viewModel: viewModel)
}
