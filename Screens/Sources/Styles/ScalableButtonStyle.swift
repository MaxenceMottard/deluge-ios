//
//  ScalableButtonStyle.swift
//  Screens
//
//  Created by Maxence Mottard on 09/11/2024.
//

import SwiftUI

struct ScalableButtonStyle: ButtonStyle {
    @State private var isPressedAnimated = false

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? 0.7 : 1)
            .scaleEffect(isPressedAnimated ? 1.08 : 1)
            .animation(.easeOut(duration: 0.1), value: isPressedAnimated)
            .onChange(of: configuration.isPressed) { _, newValue in
                isPressedAnimated = newValue
            }
    }
}

extension ButtonStyle where Self == ScalableButtonStyle {
    static var scalable: ScalableButtonStyle {
        ScalableButtonStyle()
    }
}


#Preview {
    Button(action: {}) {
        Color.red
            .frame(width: 200, height: 200)
    }
    .buttonStyle(.scalable)
}
