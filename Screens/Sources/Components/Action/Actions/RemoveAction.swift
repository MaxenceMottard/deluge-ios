//
//  RemoveAction.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

public struct RemoveAction: Action {
    public let icon: Image = Image(systemName: "trash.fill")
    public let label: LocalizedStringKey = "action.remove"
    public let action: () async -> Void
}

public extension Action where Self == RemoveAction {
    static func remove(action: @escaping () async -> Void) -> RemoveAction {
        RemoveAction(action: action)
    }
}

