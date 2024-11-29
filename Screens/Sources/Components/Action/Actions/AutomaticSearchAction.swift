//
//  AutomaticSearchAction.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

public struct AutomaticSearchAction: Action {
    public let icon: Image = Image(systemName: "magnifyingglass")
    public let label: LocalizedStringKey = "action.automaticSearch"
    public let action: () async -> Void
}

public extension Action where Self == AutomaticSearchAction {
    static func automaticSearch(action: @escaping () async -> Void) -> AutomaticSearchAction {
        AutomaticSearchAction(action: action)
    }
}

