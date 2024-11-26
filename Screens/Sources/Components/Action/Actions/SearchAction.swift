//
//  SearchAction.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

public struct SearchAction: Action {
    public let icon: Image = Image(systemName: "magnifyingglass")
    public let label: LocalizedStringKey = "action.search"
    public let action: () async -> Void
}

public extension Action where Self == SearchAction {
    static func search(action: @escaping () async -> Void) -> SearchAction {
        SearchAction(action: action)
    }
}

