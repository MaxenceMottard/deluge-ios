//
//  HomeViewItem.swift
//  Screens
//
//  Created by Maxence Mottard on 11/11/2024.
//

import SwiftUI
import Workers
import NukeUI

struct HomeViewItem: View {
    @State private var size: CGSize = .zero
    @State private var scale: CGFloat = .zero

    let media: any Media
    let onTap: () -> Void

    var body: some View {
        Button(action: { onTap() }) {
            VStack {
                ViewWithRatio(ratio: 0.68) {
                    LazyImage(url: URL(string: media.poster)) { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
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
                    .cornerRadius(8)
                }
                .readSize($size)
                .scaleEffect(scale)

                Text(media.title)
                    .lineLimit(1)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(String(media.year))
                    .font(.caption2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.gray)
                    .hidden(media.year == 0)
            }
        }
        .buttonStyle(.scalable(scale: $scale))
    }
}

#Preview {
    HomeViewItem(media: Serie.preview(), onTap: {})
}
