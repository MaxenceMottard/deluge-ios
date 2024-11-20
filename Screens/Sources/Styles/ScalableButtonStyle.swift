//
//  ScalableButtonStyle.swift
//  Screens
//
//  Created by Maxence Mottard on 09/11/2024.
//

import SwiftUI

struct ScalableButtonStyle: ButtonStyle {
    private enum Constants {
        static let defaultScale: CGFloat = 1
        static let pressedScale: CGFloat = 1.05
        static let defaultOpacity: CGFloat = 1
        static let pressedOpacity: CGFloat = 0.7
        static let animationDuration: CGFloat = 0.1
    }

    @Binding var scaleValue: CGFloat

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .opacity(configuration.isPressed ? Constants.pressedOpacity : Constants.defaultOpacity)
            .animation(.easeOut(duration: Constants.animationDuration), value: scaleValue)
            .onChange(of: configuration.isPressed) { _, newValue in
                scaleValue = newValue ? Constants.pressedScale : Constants.defaultScale
            }
            .onAppear {
                scaleValue = configuration.isPressed ? Constants.pressedScale : Constants.defaultScale
            }
    }
}

extension ButtonStyle where Self == ScalableButtonStyle {
    static func scalable(scale: Binding<CGFloat>) -> ScalableButtonStyle {
        ScalableButtonStyle(scaleValue: scale)
    }
}


#Preview {
    @Previewable @State var scale: CGFloat = 1

    Button(action: {}) {
        Color.red
            .frame(width: 200, height: 200)
            .overlay {
                Color.green.padding()
                    .scaleEffect(scale)
            }
    }
    .buttonStyle(.scalable(scale: $scale))
}
