//
//  Instance.swift
//  Utils
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Foundation

public struct Instance: Identifiable, Sendable, Codable, Equatable, Hashable {
    public let type: InstanceType
    public let name: String
    public let url: String
    public let apiKey: String

    public var id: Int { hashValue }

    public init(type: InstanceType, name: String, url: String, apiKey: String) {
        self.name = name
        self.url = url
        self.apiKey = apiKey
        self.type = type
    }

    public enum InstanceType: Codable, CaseIterable, Identifiable, Sendable {
        case sonarr
        case radarr

        public var id: Self { self }
    }
}
