//
//  Quality.swift
//  Workers
//
//  Created by Maxence Mottard on 24/11/2024.
//

import Foundation

public struct Quality: Sendable, Equatable {
    public let id: Int
    public let name: String
    public let source: String
    public let resolution: Int

    public init(id: Int, name: String, source: String, resolution: Int) {
        self.id = id
        self.name = name
        self.source = source
        self.resolution = resolution
    }
}
