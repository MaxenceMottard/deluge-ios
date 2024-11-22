//
//  TapticEngineWorking.swift
//  Utils
//
//  Created by Maxence Mottard on 22/11/2024.
//

import Foundation

public enum TapticType {
    case success
}

public protocol TapticEngineWorking {
    func trigger(type: TapticType)
}
