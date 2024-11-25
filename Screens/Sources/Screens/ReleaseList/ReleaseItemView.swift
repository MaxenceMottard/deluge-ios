//
//  ReleaseItemView.swift
//  Screens
//
//  Created by Maxence Mottard on 25/11/2024.
//

import SwiftUI
import Workers
import DesignSystem

struct ReleaseItemView: View {
    let result: Release
    let openInBrowser: (String) -> Void

    var body: some View {
        ContainerView {
            VStack(spacing: 10) {
                Button(action: { openInBrowser(result.infoUrl) }) {
                    Text(result.title)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                }

                HStack {
                    Text(result.indexer)
                    FileQualityView(quality: result.quality.name)
                    CounterView(
                        leftValue: "\(result.seeders)",
                        rightValue: "\(result.leechers)",
                        status: .neutral
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                ActionsStack(actions: [
                ])
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
        }
    }
}

#Preview {
    ReleaseItemView(
        result: .preview(),
        openInBrowser: { _ in }
    )
}
