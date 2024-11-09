//
//  ImageCacheWorking.swift
//  Utils
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Foundation

// sourcery: AutoMockable
public protocol ImageCacheWorking: Sendable {
    func cache(for url: URL?) async
}

extension ImageCacheWorking {
    public func cache(string urlString: String?) async {
        guard let urlString = urlString else { return }
        await cache(for: URL(string: urlString))
    }
}
