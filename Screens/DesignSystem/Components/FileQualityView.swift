//
//  FileQualityView.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

public struct FileQualityView: View {
    private let quality: String?

    public init(quality: String?) {
        self.quality = quality
    }

    public var body: some View {
        if let quality {
            Text(quality)
                .font(.caption)
                .padding(.vertical, 2)
                .padding(.horizontal, 4)
                .background(.gray)
                .cornerRadius(5)
        }
    }
}

#Preview {
    FileQualityView(quality: "WEBDL-1080p")
}
