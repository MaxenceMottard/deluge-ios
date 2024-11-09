//
//  Instance.swift
//  Utils
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Foundation

public struct Instance: Identifiable, Sendable, Codable, Equatable, Hashable {
    public let url: String
    public let apiKey: String

    public var id: Int { hashValue }

    public init(url: String, apiKey: String) {
        self.url = url
        self.apiKey = apiKey
    }
}
