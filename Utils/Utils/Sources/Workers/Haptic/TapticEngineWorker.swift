//
//  TapticEngineWorker.swift
//  Utils
//
//  Created by Maxence Mottard on 22/11/2024.
//

import UIKit

struct TapticEngineWorker: TapticEngineWorking {
    func triggerNotification(type: TapticNotificationType) {
        let type = getNotificationType(for: type)
        let generator = UINotificationFeedbackGenerator()
        generator.prepare()
        generator.notificationOccurred(type)
    }

    func triggerSelectionChanged() {
        let generator = UISelectionFeedbackGenerator()
        generator.prepare()
        generator.selectionChanged()
    }

    private func getNotificationType(for type: TapticNotificationType) -> UINotificationFeedbackGenerator.FeedbackType {
        switch type {
        case .success: .success
        case .error: .error
        }
    }
}
