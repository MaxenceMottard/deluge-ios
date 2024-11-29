//
//  RefreshAction.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

public struct RefreshAction: Action {
    public let icon: Image = Image(systemName: "arrow.trianglehead.2.clockwise")
    public let label: LocalizedStringKey = "action.refresh"
    public let action: () async -> Void
}

public extension Action where Self == RefreshAction {
    static func refresh(action: @escaping () async -> Void) -> RefreshAction {
        RefreshAction(action: action)
    }
}

