//
//  OpenURLWorking.swift
//  Utils
//
//  Created by Maxence Mottard on 25/11/2024.
//

import UIKit

// sourcery: AutoMockable
public protocol OpenURLWorking {
    func open(url: URL)
}

struct OpenURLWorker: OpenURLWorking {
    func open(url: URL) {
        UIApplication.shared.open(url)
    }
}
