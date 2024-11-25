//
//  ImageCacheWorker.swift
//  
//
//  Created by Maxence Mottard on 14/02/2024.
//

import Foundation
import Nuke

// sourcery: AutoMockable
public protocol ImageCacheWorking: Sendable {
    func cache(for url: URL?) async
}

struct ImageCacheWorker: ImageCacheWorking {
    private static let cache = try! DataCache(name: "com.trimarr.media.cache")
    private static let pipeline = ImagePipeline {
        $0.dataCache = cache
    }

    init() {}
    
    func cache(for url: URL?) async {
        guard let url else { return }
        _ = try? await Self.pipeline.image(for: url)
    }
}

extension ImageCacheWorking {
    public func cache(string urlString: String?) async {
        guard let urlString = urlString else { return }
        await cache(for: URL(string: urlString))
    }
}

