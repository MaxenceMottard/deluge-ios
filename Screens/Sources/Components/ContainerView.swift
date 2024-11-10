//
//  ContainerView.swift
//  Screens
//
//  Created by Maxence Mottard on 09/11/2024.
//

import SwiftUI

struct ContainerView<Content: View>: View {
    var content: () -> Content

    var body: some View {
        content()
            .background(.white.opacity(0.1))
            .roundedBorder(.gray, width: 1, radius: 8)
    }
}

#Preview {
    ContainerView {
        Color.clear
            .frame(height: 200)
    }
    .padding()
}
