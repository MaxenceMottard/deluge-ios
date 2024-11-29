//
//  QualityProfile.swift
//  Workers
//
//  Created by Maxence Mottard on 26/11/2024.
//


public struct QualityProfile: Sendable, Identifiable, Hashable {
    public let id: Int
    public let name: String
    public let upgradeAllowed: Bool
    public let cutoff: Int

    public init(id: Int, name: String, upgradeAllowed: Bool, cutoff: Int) {
        self.id = id
        self.name = name
        self.upgradeAllowed = upgradeAllowed
        self.cutoff = cutoff
    }
}

extension GetQualityProfilesWorkerDecodable {
    func toDomain() -> QualityProfile {
        return QualityProfile(
            id: id,
            name: name,
            upgradeAllowed: upgradeAllowed,
            cutoff: cutoff
        )
    }
}

extension [GetQualityProfilesWorkerDecodable] {
    func toDomain() -> [QualityProfile] {
        return self.map { $0.toDomain() }
    }
}
