//
//  SearchItemView.swift
//  Screens
//
//  Created by Maxence Mottard on 26/11/2024.
//

import SwiftUI
import Workers
import DesignSystem
import NukeUI

struct SearchItemView: View {
    let item: SearchSerieResult
    let tapOnItem: () -> Void

    var body: some View {
        Button {
            tapOnItem()
        } label: {
            ContainerView {
                VStack {
                    HStack(alignment: .top) {
                        ViewWithRatio(ratio: 0.68) {
                            LazyImage(url: URL(string: item.poster)) { state in
                                if let image = state.image {
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                } else {
                                    Color.clear
                                }
                            }
                            .cornerRadius(8)
                        }
                        .frame(width: 100)

                        VStack(alignment: .leading, spacing: 7) {
                            Text(item.title)
                                .multilineTextAlignment(.leading)
                                .bold()

                            if let description = item.description {
                                Text(description)
                                    .multilineTextAlignment(.leading)
                                    .font(.callout)
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .tint(.white)
    }
}

#Preview {
    SearchItemView(item: .preview(), tapOnItem: {})
}
