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
    let release: Release
    let openInBrowser: () -> Void
    let downloadRelease: () async -> Void

    var body: some View {
        ContainerView {
            VStack(spacing: 10) {
                Button(action: { openInBrowser() }) {
                    Text(release.title)
                        .multilineTextAlignment(.leading)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .lineLimit(2)
                }

                HStack {
                    Text(release.indexer)
                    FileQualityView(quality: release.quality.name)
                    FileSizeView(size: release.size)
                    CounterView(
                        leftValue: "\(release.seeders)",
                        rightValue: "\(release.leechers)",
                        status: .neutral
                    )
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                ActionsStack(actions: [
                    .download { await downloadRelease() },
                ])
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding()
        }
    }
}

#Preview {
    ReleaseItemView(
        release: .preview(),
        openInBrowser: {},
        downloadRelease: {}
    )
}
