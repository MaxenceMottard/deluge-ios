//
//  DownloadAction.swift
//  Screens
//
//  Created by Maxence Mottard on 23/11/2024.
//

import SwiftUI

public struct DownloadAction: Action {
    public let icon: Image = Image(systemName: "square.and.arrow.down")
    public let label: LocalizedStringKey = "action.download"
    public let action: () async -> Void
}

public extension Action where Self == DownloadAction {
    static func download(action: @escaping () async -> Void) -> DownloadAction {
        DownloadAction(action: action)
    }
}

