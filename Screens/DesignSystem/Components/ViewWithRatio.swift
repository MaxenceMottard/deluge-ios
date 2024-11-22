//
//  ViewWithRatio.swift
//  Screens
//
//  Created by Maxence Mottard on 09/11/2024.
//

import SwiftUI

public struct ViewWithRatio<Content: View>: View {
    @State private var size: CGSize = .zero

    let ratio: Double
    @ViewBuilder let content: () -> Content

    public init(ratio: Double, content: @escaping () -> Content) {
        self.ratio = ratio
        self.content = content
    }

    private var height: CGFloat {
        size.width / ratio
    }

    public var body: some View {
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
