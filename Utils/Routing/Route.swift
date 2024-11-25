//
//  Router+Route.swift
//  fore
//
//  Created by Maxence Mottard on 25/05/2024.
//

import SwiftUI

public protocol Route {
    @MainActor
    func viewController(router: Router) -> UIViewController
}

extension Route {
    static var name: String {
        return String(describing: self)
    }
}
