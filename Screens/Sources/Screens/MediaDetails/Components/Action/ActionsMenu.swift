//
//  ActionsMenu.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

struct ActionsMenu: View {
    @State private var size: CGSize = .zero

    private let _actions: [any Action]
    private var actions: [AnyAction] {
        _actions.map({ AnyAction(action: $0) })
    }

    init(actions: [any Action]) {
        self._actions = actions
    }

    private let icon: Image = Image(systemName: "ellipsis")

    var body: some View {
        icon
            .frame(height: size.width)
            .readSize($size)
            .hidden()
            .overlay {
                Menu {
                    ForEach(actions) { action in
                        Button {
                            Task { await action.action() }
                        } label: {
                            action.icon
                            Text(action.label)
                        }
                    }
                } label: {
                    icon
                        .frame(width: 40, height: 40)
                        .contentShape(Rectangle())
                }
                .tint(.white)
            }
    }
}

#Preview {
    ActionsMenu(
        actions: [
            .search(action: {}),
        ]
    )
}
