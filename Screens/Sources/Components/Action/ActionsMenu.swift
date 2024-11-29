//
//  ActionsMenu.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

public struct ActionsMenu: View {
    @State private var size: CGSize = .zero

    private let actions: [AnyAction]

    public init(actions: [(any Action)?]) {
        self.actions = actions
            .compactMap({ $0 })
            .map({ AnyAction(action: $0) })
    }

    private let icon: Image = Image(systemName: "ellipsis")

    public var body: some View {
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
                            Text(action.label, bundle: .module)
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
    ActionsMenu(actions: [
        .automaticSearch(action: {}),
        .interactiveSearch(action: {}),
    ])
}
