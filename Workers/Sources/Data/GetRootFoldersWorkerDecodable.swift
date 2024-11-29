//
//  GetRootFoldersWorkerDecodable.swift
//  Workers
//
//  Created by Maxence Mottard on 26/11/2024.
//

import Foundation

struct GetRootFoldersWorkerDecodable: Decodable {
    let id: Int
    let path: String
    let accessible: Bool
    let freeSpace: Int
}
