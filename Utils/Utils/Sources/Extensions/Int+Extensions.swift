//
//  Int+Extensions.swift
//  Screens
//
//  Created by Maxence Mottard on 22/11/2024.
//

import Foundation

public extension Int {
    func toGigabytes() -> Double {
        let bytesPerGigabyte = 1_073_741_824.0
        return Double(self) / bytesPerGigabyte
    }
}
