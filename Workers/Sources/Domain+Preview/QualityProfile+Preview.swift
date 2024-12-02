//
//  QualityProfile+Preview.swift
//  Workers
//
//  Created by Maxence Mottard on 29/11/2024.
//

import Foundation

public extension QualityProfile {
    static func preview(
        id: Int = UUID().hashValue,
        name: String = "HB",
        upgradeAllowed: Bool = false,
        cutoff: Int = 0
    ) -> QualityProfile {
        return QualityProfile(
            id: id,
            name: name,
            upgradeAllowed: upgradeAllowed,
            cutoff: cutoff
        )
    }
}

public extension [QualityProfile] {
    static var preview: [QualityProfile] {
        [
            .preview(name: "Any"),
            .preview(name: "HD - 1080p"),
            .preview(name: "HD - 720p"),
            .preview(name: "SD"),
        ]
    }
}
