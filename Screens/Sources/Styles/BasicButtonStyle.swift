//
//  BasicButtonStyle.swift
//  Screens
//
//  Created by Maxence Mottard on 09/11/2024.
//

import SwiftUI
import DesignSystem

struct BasicButtonStyle: ButtonStyle {
    private enum Constants {
        static let disabledOpacity: Double = 0.3
        static let pressedOpacity: Double = 0.5
        static let defaultOpacity: Double = 1
    }

    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        ContainerView {
            configuration.label
                .bold()
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.white.opacity(0.1))
                .opacity(opacity(configuration))
        }
    }

    private func opacity(_ configuration: Configuration) -> Double {
        if !isEnabled {
            Constants.disabledOpacity
        } else if configuration.isPressed {
            Constants.pressedOpacity
        } else {
            Constants.defaultOpacity
        }
    }
}

extension ButtonStyle where Self == BasicButtonStyle {
    static var basic: BasicButtonStyle {
        BasicButtonStyle()
    }
}

#Preview {
    Button("Connect", action: {})
        .buttonStyle(.basic)
}
