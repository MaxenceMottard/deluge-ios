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
    var isHidden: Bool { get }
    var action: () async -> Void { get }
}

extension Action {
    public var isHidden: Bool { false }
}

public struct AnyAction: Action, Identifiable {
    public var id: UUID = UUID()

    private let _icon: Image
    private let _label: LocalizedStringKey
    private let _action: () async -> Void
    private let _isHidden: Bool

    public var icon: Image { _icon }
    public var label: LocalizedStringKey { _label }
    public var action: () async -> Void { _action }
    public var isHidden: Bool { _isHidden }

    init(action: any Action) {
        self._icon = action.icon
        self._label = action.label
        self._action = action.action
        self._isHidden = action.isHidden
    }
}
