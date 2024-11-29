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

struct MediaDetailsView: View {
    @State var viewModel: any MediaDetailsViewModel

    var body: some View {
        ScrollView {
            Header(media: viewModel.media)

            VStack {
                if let serie = viewModel.media as? Workers.Serie {
                    MediaDetailsSerieView(viewModel: viewModel.getSerieViewModel(serie: serie))
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
        viewModel.getSerieViewModelSerieSerieAnyMediaDetailsSerieViewModelReturnValue = {
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

        return viewModel
    }()

    MediaDetailsView(viewModel: viewModel)
}

#Preview("Movie") {
    let viewModel: any MediaDetailsViewModel = {
        let viewModel = MockMediaDetailsViewModel()
        viewModel.media = Movie.preview()

        return viewModel
    }()

    MediaDetailsView(viewModel: viewModel)
}
