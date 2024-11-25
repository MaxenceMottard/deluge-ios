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
    @State var viewModel: any MediaDetailsViewModeling

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
    let viewModel: any MediaDetailsViewModeling = {
        let viewModel = MediaDetailsViewModelingMock()
        viewModel.media = Serie.preview()
        viewModel.getSerieViewModelSerieSerieAnyMediaDetailsSerieViewModelingReturnValue = {
            let viewModel = MediaDetailsSerieViewModelingMock()
            viewModel.serie = .preview()
            viewModel.seasons = viewModel.serie.seasons
            viewModel.getEpisodesOfSerieSeasonSerieEpisodeReturnValue = .preview.prefix(6).map({ $0 })
            viewModel.getStatusOfSerieSeasonSeasonStatusReturnValue = .missingNonMonitored
            viewModel.getEpisodeFileOfSerieEpisodeSerieEpisodeFileReturnValue = .preview()

            return viewModel
        }()

        return viewModel
    }()

    MediaDetailsView(viewModel: viewModel)
}

#Preview("Movie") {
    let viewModel: any MediaDetailsViewModeling = {
        let viewModel = MediaDetailsViewModelingMock()
        viewModel.media = Movie.preview()

        return viewModel
    }()

    MediaDetailsView(viewModel: viewModel)
}
