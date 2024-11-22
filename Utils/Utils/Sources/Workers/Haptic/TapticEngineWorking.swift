//
//  TapticEngineWorking.swift
//  Utils
//
//  Created by Maxence Mottard on 22/11/2024.
//

import Foundation

public enum TapticNotificationType {
    case success
    case error
}

public protocol TapticEngineWorking {
    func triggerNotification(type: TapticNotificationType)
    func triggerSelectionChanged()
}
