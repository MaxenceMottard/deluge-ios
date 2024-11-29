//
//  GetQualityProfilesWorkerDecodable.swift
//  Workers
//
//  Created by Maxence Mottard on 26/11/2024.
//

import Foundation

struct GetQualityProfilesWorkerDecodable: Decodable {
    let id: Int
    let name: String
    let upgradeAllowed: Bool
    let cutoff: Int
}
