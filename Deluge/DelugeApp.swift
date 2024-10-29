//
//  DelugeApp.swift
//  Deluge
//
//  Created by Maxence Mottard on 28/10/2024.
//

import SwiftUI
import Screens

@main
struct DelugeApp: App {
    var body: some Scene {
        WindowGroup {
            InitialView()
                .ignoresSafeArea()
        }
    }
}
