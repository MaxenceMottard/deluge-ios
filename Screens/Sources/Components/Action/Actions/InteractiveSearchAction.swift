//
//  InteractiveSearchAction.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

public struct InteractiveSearchAction: Action {
    public let icon: Image = Image(systemName: "person.fill")
    public let label: LocalizedStringKey = "action.interactiveSearch"
    public let action: () async -> Void
}

public extension Action where Self == InteractiveSearchAction {
    static func interactiveSearch(action: @escaping () async -> Void) -> InteractiveSearchAction {
        InteractiveSearchAction(action: action)
    }
}

