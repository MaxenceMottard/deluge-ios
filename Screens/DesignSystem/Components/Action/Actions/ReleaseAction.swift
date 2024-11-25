//
//  ReleaseAction.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

public struct ReleaseAction: Action {
    public let icon: Image = Image(systemName: "person.fill")
    public let label: String = "Release"
    public let action: () async -> Void
}

public extension Action where Self == ReleaseAction {
    static func release(action: @escaping () async -> Void) -> ReleaseAction {
        ReleaseAction(action: action)
    }
}

