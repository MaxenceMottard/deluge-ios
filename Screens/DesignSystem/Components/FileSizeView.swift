//
//  FileSizeView.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI
import Utils

public struct FileSizeView: View {
    private let size: Int

    public init(size: Int) {
        self.size = size
    }

    public var body: some View {
        Text("\(size.toGigabytes().toString(numberOfDecimals: 1)) GB")
            .foregroundStyle(.gray)
            .font(.callout)
            .hidden(size < 1)
    }
}

#Preview {
    FileSizeView(size: 10031312462)
}
