//
//  TapticEngineWorker.swift
//  Utils
//
//  Created by Maxence Mottard on 22/11/2024.
//

import UIKit

struct TapticEngineWorker: TapticEngineWorking {
    func trigger(type: TapticType) {
        let type = getNativeType(for: type)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    private func getNativeType(for type: TapticType) -> UINotificationFeedbackGenerator.FeedbackType {
        switch type {
        case .success:
            return .success
        }
    }
}
