//
//  SearchAction.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

struct SearchAction: Action {
    let icon: Image = Image(systemName: "magnifyingglass")
    let label: String = "Search"
    let action: () async -> Void
}

extension Action where Self == SearchAction {
    static func search(action: @escaping () async -> Void) -> SearchAction {
        SearchAction(action: action)
    }
}

