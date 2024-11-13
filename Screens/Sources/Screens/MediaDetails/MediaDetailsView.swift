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
    @State private var posterSize: CGSize = .zero
    @State var viewModel: MediaDetailsViewModel

    var body: some View {
        ScrollView {
            VStack {
                poster
                    .overlay(alignment: .bottom) {
                        LinearGradient(
                            colors: [
                                .clear,
                                .black.opacity(0.5),
                                .black.opacity(0.6),
                                .black
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: posterSize.height * 0.7)
//                        Color.red
                    }
                    .readSize($posterSize)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
    }

    private var poster: some View {
        ViewWithRatio(ratio: 0.68) {
            LazyImage(url: URL(string: viewModel.media.poster)) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if state.isLoading {
                    Color.clear
                } else {
                    ContainerView {
                        Text(viewModel.media.title)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(8)
                    }
                }
            }
        }
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
