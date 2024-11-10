//
//  View+Extensions.swift
//  Screens
//
//  Created by Maxence Mottard on 10/11/2024.
//

import SwiftUI

extension View {
    @ViewBuilder @inlinable nonisolated public func hidden(_ isHidden: Bool) -> some View {
        if isHidden {
            hidden()
        } else {
            self
        }
    }
}
