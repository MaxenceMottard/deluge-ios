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
            VStack {
                Header(media: viewModel.media)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }
}

#Preview("Serie") {
    let viewModel: any MediaDetailsViewModeling = {
        let viewModel = MediaDetailsViewModelingMock()
        viewModel.media = Serie.preview()

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
