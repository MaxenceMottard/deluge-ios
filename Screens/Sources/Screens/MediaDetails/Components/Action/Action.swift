//
//  Action.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

protocol Action {
    var icon: Image { get }
    var label: String { get }
    var action: () async -> Void { get }
}

struct AnyAction: Action, Identifiable {
    var id: UUID = UUID()

    private let _icon: Image
    private let _label: String
    private let _action: () async -> Void

    var icon: Image { _icon }
    var label: String { _label }
    var action: () async -> Void { _action }

    init(action: any Action) {
        self._icon = action.icon
        self._label = action.label
        self._action = action.action
    }
}
