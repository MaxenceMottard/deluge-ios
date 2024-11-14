//
//  Media.swift
//  Workers
//
//  Created by Maxence Mottard on 13/11/2024.
//

import Foundation

public protocol Media: Sendable, Identifiable {
    var id: Int { get }
    var title: String { get }
    var description: String { get }
    var year: Int { get }
    var poster: String? { get }
    var banner: String? { get }
}
