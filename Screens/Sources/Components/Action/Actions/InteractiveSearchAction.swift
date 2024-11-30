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
    public let isHidden: Bool
    public let action: () async -> Void
}

public extension Action where Self == InteractiveSearchAction {
    static func interactiveSearch(isHidden: Bool = false, action: @escaping () async -> Void) -> InteractiveSearchAction {
        InteractiveSearchAction(isHidden: isHidden, action: action)
    }
}

