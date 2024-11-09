//
//  URL+Extensions.swift
//  Utils
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Foundation

public extension URL {
    init?(string: String?) {
        guard let string else { return nil }
        self.init(string: string)
    }
}
