//
//  Action.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

public protocol Action {
    var icon: Image { get }
    var label: LocalizedStringKey { get }
    var action: () async -> Void { get }
}

public struct AnyAction: Action, Identifiable {
    public var id: UUID = UUID()

    private let _icon: Image
    private let _label: LocalizedStringKey
    private let _action: () async -> Void

    public var icon: Image { _icon }
    public var label: LocalizedStringKey { _label }
    public var action: () async -> Void { _action }

    init(action: any Action) {
        self._icon = action.icon
        self._label = action.label
        self._action = action.action
    }
}
