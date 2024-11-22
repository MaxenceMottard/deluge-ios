//
//  ContainerView.swift
//  Screens
//
//  Created by Maxence Mottard on 09/11/2024.
//

import SwiftUI

public struct ContainerView<Content: View>: View {
    @Environment(\.theme) var theme

    let content: () -> Content

    public init(content: @escaping () -> Content) {
        self.content = content
    }

    public var body: some View {
        content()
            .background(theme.colors.containerBackground)
            .cornerRadius(10)
    }
}

#Preview {
    ContainerView {
        Color.clear
            .frame(height: 200)
    }
    .padding()
}
