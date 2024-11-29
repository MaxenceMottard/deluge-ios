//
//  Tab+Kind.swift
//  
//
//  Created by Maxence Mottard on 28/05/2024.
//

import Routing
import SwiftUI

extension Tab {
    enum Kind {
        case home
        case search
    }
}

extension Tab.Kind {
    var initialView: any Route {
        switch self {
        case .home:
            Route.Home()
        case .search:
            Route.Search()
        }
    }

    var image: UIImage? {
        switch self {
        case .home:
            UIImage(systemName: "house")
        case .search:
            UIImage(systemName: "magnifyingglass")
        }
    }

    var selectedImage: UIImage? {
        switch self {
        case .home:
            UIImage(systemName: "house.fill")
        case .search:
            UIImage(systemName: "magnifyingglass")
        }
    }

    var title: String {
        return ""
    }
}
