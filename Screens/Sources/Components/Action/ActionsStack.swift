//
//  ActionsStack.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

public struct ActionsStack: View {
    private let _actions: [any Action]
    private var actions: [AnyAction] {
        _actions.map({ AnyAction(action: $0) })
    }

    public init(actions: [any Action]) {
        self._actions = actions
    }

    public var body: some View {
        HStack {
            ForEach(actions) { action in
                Button {
                    Task { await action.action() }
                } label: {
                    action.icon
                }
            }
        }
        .tint(.white)
    }
}

#Preview {
    ActionsStack(actions: [
        .automaticSearch(action: {}),
    ])
}
