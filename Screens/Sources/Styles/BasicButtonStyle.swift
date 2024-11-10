//
//  BasicButtonStyle.swift
//  Screens
//
//  Created by Maxence Mottard on 09/11/2024.
//

import SwiftUI

struct BasicButtonStyle: ButtonStyle {
    @Environment(\.isEnabled) private var isEnabled

    func makeBody(configuration: Configuration) -> some View {
        ContainerView {
            configuration.label
                .bold()
                .frame(maxWidth: .infinity)
                .padding(.horizontal)
                .padding(.vertical, 10)
                .background(.white.opacity(0.1))
                .opacity(configuration.isPressed ? 0.5 : 1)
        }
    }

    private func opacity(_ configuration: Configuration) -> Double {
        if !isEnabled {
            return 0.3
        }

        if configuration.isPressed {
            return 0.5
        }

        return 1
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
