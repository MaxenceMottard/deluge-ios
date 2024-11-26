//
//  Tab.swift
//  Screens
//
//  Created by Maxence Mottard on 26/11/2024.
//

import SwiftUI
import Routing

public struct Tab: UIViewControllerRepresentable {
    let tabs: [Kind] = [.home, .search]

    public init() {}

    public func makeUIViewController(context: Context) -> UITabBarController {
        let viewControllers = tabs.map { kind in
            let router = Router()
            let viewController = kind.initialView.viewController(router: router)
            router.setRoot(viewController: viewController)

            let navigationController = router.navigationController
            navigationController.tabBarItem.title = kind.title
            navigationController.tabBarItem.image = kind.image
            navigationController.tabBarItem.selectedImage = kind.selectedImage
            navigationController.tabBarItem.selectedImage = kind.selectedImage

            return navigationController
        }

        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers

        return tabBarController
    }

    public func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {

    }
}
