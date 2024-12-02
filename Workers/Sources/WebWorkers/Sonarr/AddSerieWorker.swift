//
//  AddSerieWorker.swift
//  Workers
//
//  Created by Maxence Mottard on 29/11/2024.
//

import Foundation
import Networking

// sourcery: AutoMockable
public protocol AddSerieWorking: Sendable {
    func run(
        serie: SearchResult,
        root: String,
        qualityProfileId: Int,
        monitor: SerieMonitor,
        serieType: SerieType,
        seasonFolder: Bool,
        searchForMissingEpisodes: Bool,
        searchForCutoffUnmetEpisodes: Bool
    ) async throws
}

struct AddSerieWorker: AddSerieWorking {
    func run(
        serie: SearchResult,
        root: String,
        qualityProfileId: Int,
        monitor: SerieMonitor,
        serieType: SerieType,
        seasonFolder: Bool,
        searchForMissingEpisodes: Bool,
        searchForCutoffUnmetEpisodes: Bool
    ) async throws {
        guard let sendableDictionary = serie.data else { throw RequestError.invalidData }

        var dictionary = sendableDictionary as [String: Any]
        dictionary["qualityProfileId"] = qualityProfileId
        dictionary["languageProfileId"] = qualityProfileId
        dictionary["seasonFolder"] = seasonFolder
        dictionary["rootFolderPath"] = root
        dictionary["seriesType"] = serieType.rawValue
        dictionary["addOptions"] = [
            "monitor": monitor.rawValue,
            "searchForMissingEpisodes": searchForMissingEpisodes,
            "searchForCutoffUnmetEpisodes": searchForCutoffUnmetEpisodes
        ]

        let data = try JSONSerialization.data(withJSONObject: dictionary)

        try await Request()
            .set(method: .POST)
            .set(path: "/api/v3/series")
            .set(contentType: .json)
            .set(interceptor: InstanceInteceptor())
            .set(body: data)
            .run()
    }
}

extension SerieMonitor: Encodable {
    public func encode(to encoder: any Encoder) throws {

    }
}
