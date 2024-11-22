//
//  Theme.swift
//  UI
//
//  Created by Maxence Mottard on 01/10/2024.
//

import SwiftUI

public struct Theme: Sendable {
    public let colors: Theme.Colors
}

public extension EnvironmentValues {
    @Entry var theme: Theme = defaultTheme
}
