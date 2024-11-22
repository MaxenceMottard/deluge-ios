//
//  RemoteImage.swift
//  Workers
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Foundation

public struct RemoteImage: Sendable {
    let path: String
    let url: String
}

extension GetSeriesWebWorkerResponse.Image {
    func toDomain() -> RemoteImage {
        RemoteImage(
            path: url,
            url: remoteUrl
        )
    }
}
