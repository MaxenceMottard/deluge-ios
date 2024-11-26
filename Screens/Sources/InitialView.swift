//
//  File.swift
//  Screens
//
//  Created by Maxence Mottard on 28/10/2024.
//

import SwiftUI
import Routing
//import Utils

public struct InitialView: View {
    public init() {}

    public var body: some View {
        Router.View(dismiss: nil, initialRoute: Route.Home())
            .tint(.white)
    }
}
