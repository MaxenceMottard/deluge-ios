//
//  Router+Route.swift
//  fore
//
//  Created by Maxence Mottard on 25/05/2024.
//

import SwiftUI

@MainActor
public protocol Route {
    var detents: [UISheetPresentationController.Detent] { get }

    func viewController(router: Router) -> UIViewController
}

extension Route {
    static var name: String {
        return String(describing: self)
    }

    public var detents: [UISheetPresentationController.Detent] {
        [.large()]
    }
}
