//
//  MediaDetailsView+Header.swift
//  Screens
//
//  Created by Maxence Mottard on 20/11/2024.
//

import SwiftUI
import Workers
import NukeUI
import DesignSystem

extension MediaDetailsView {
    struct Header: View {
        @State private var posterSize: CGSize = .zero

        let media: any Media

        var body: some View {
            poster
                .frame(height: 500)
                .blur(radius: 20)
                .clipped()
                .overlay(alignment: .bottom) {
                    LinearGradient(
                        colors: [.clear, .black],
                        startPoint: .top,
                        endPoint: .bottom
                    )
                    .frame(height: posterSize.height * 0.5)
                }
                .overlay(alignment: .bottom) {
                    ViewWithRatio(ratio: 0.68) {
                        poster
                    }
                    .frame(width: 200)
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                }
                .readSize($posterSize)
        }

        private var poster: some View {
            LazyImage(url: URL(string: media.poster)) { state in
                if let image = state.image {
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } else if state.isLoading {
                    Color.clear
                } else {
                    ContainerView {
                        Text(media.title)
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

#Preview {
    MediaDetailsView.Header(media: Serie.preview())
}
