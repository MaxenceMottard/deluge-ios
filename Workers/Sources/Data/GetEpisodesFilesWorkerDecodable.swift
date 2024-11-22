//
//  GetEpisodesFilesWorkerDecodable.swift
//  Workers
//
//  Created by Maxence Mottard on 22/11/2024.
//

import Foundation

struct GetEpisodesFilesWorkerDecodable: Decodable {
    let id: Int
    let seriesId: Int
    let seasonNumber: Int
    let relativePath: String
    let path: String
    let size: Int
    let dateAdded: String
    let quality: Quality
    let mediaInfo: MediaInformation

    struct Quality: Decodable {
        let quality: Information

        struct Information: Decodable {
            let id: Int
            let name: String
            let source: String
            let resolution: Int
        }
    }

    struct MediaInformation: Decodable {
        let audioBitrate: Int
        let audioChannels: Double
        let audioCodec: String
        let audioLanguages: String
        let audioStreamCount: Int
        let videoBitDepth: Int
        let videoBitrate: Int
        let videoCodec: String
        let videoFps: Double
        let videoDynamicRange: String
        let videoDynamicRangeType: String
        let resolution: String
        let runTime: String
        let scanType: String
        let subtitles: String
    }
}
