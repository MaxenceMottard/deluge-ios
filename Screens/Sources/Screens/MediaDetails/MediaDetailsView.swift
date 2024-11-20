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
    @State var viewModel: MediaDetailsViewModel

    var body: some View {
        ScrollView {
            VStack {
                Header(media: viewModel.media)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

#Preview("Serie") {
    MediaDetailsView(
        viewModel: MediaDetailsViewModel(
            media: Serie.preview(),
            dependencies: MediaDetailsViewModel.Dependencies(
                router: Router()
            )
        )
    )
}

#Preview("Movie") {
    MediaDetailsView(
        viewModel: MediaDetailsViewModel(
            media: Movie.preview(),
            dependencies: MediaDetailsViewModel.Dependencies(
                router: Router()
            )
        )
    )
}
