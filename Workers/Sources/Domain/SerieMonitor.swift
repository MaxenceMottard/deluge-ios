//
//  SerieMonitor.swift
//  Workers
//
//  Created by Maxence Mottard on 29/11/2024.
//

import Foundation

public enum SerieMonitor: String, Sendable, CaseIterable {
    case all
    case future
    case missing
    case existing
    case firstSeason
    case lastSeason
    case pilot
    case recent
    case monitorSpecials
    case unmonitorSpecials
    case none
}
