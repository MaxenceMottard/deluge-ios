//
//  View+Extensions.swift
//  Screens
//
//  Created by Maxence Mottard on 10/11/2024.
//

import SwiftUI

struct IsHiddenModifier: ViewModifier {
    let isHidden: Bool

    func body(content: Content) -> some View {
        if isHidden {
            content.hidden()
        } else {
            content
        }
    }
}

extension View {
    nonisolated func hidden(_ isHidden: Bool) -> some View {
        self.modifier(IsHiddenModifier(isHidden: isHidden))
    }
}
