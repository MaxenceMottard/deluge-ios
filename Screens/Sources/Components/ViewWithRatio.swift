//
//  ViewWithRatio.swift
//  Screens
//
//  Created by Maxence Mottard on 09/11/2024.
//

import SwiftUI

struct ViewWithRatio<Content: View>: View {
    @State private var size: CGSize = .zero

    let ratio: Double
    @ViewBuilder let content: () -> Content

    private var height: CGFloat {
        size.width / ratio
    }

    var body: some View {
        content()
            .frame(width: size.width, height: height)
            .frame(maxWidth: .infinity)
            .readSize($size)
    }
}

#Preview {
    ViewWithRatio(ratio: 0.5) {
        Color.red
    }
    .frame(width: 200)
    .background(Color.blue)
}
