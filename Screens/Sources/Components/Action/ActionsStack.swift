//
//  ActionsStack.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

public struct ActionsStack: View {
    private var actions: [AnyAction]

    public init(actions: [(any Action)]) {
        self.actions = actions.map({ AnyAction(action: $0) })
    }

    public var body: some View {
        HStack {
            ForEach(actions) { action in
                if !action.isHidden {
                    Button {
                        Task { await action.action() }
                    } label: {
                        action.icon
                    }
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
