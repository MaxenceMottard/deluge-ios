//
//  Double+Extensions.swift
//  Screens
//
//  Created by Maxence Mottard on 22/11/2024.
//

import Foundation

extension Double {
    func toString(numberOfDecimals: Int) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = numberOfDecimals
        formatter.minimumFractionDigits = numberOfDecimals
        formatter.numberStyle = .decimal

        return formatter.string(from: NSNumber(value: self)) ?? "0"
    }
}
