//
//  Date+Extensions.swift
//  Screens
//
//  Created by Maxence Mottard on 21/11/2024.
//

import Foundation

public extension Date {
    static var today: Date { Date() }

    func add(days: Int) -> Date? {
        return Calendar.current.date(byAdding: .day, value: days, to: self)
    }
}
