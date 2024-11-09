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
        let router = Router()
        let initialRoute = Route.Home()
        let initialViewcontroller = initialRoute.viewController(router: router)
        router.setRoot(viewController: initialViewcontroller)
        let navigationController = router.navigationController

        return AnyUIViewControllerRepresentable(viewController: navigationController)
    }
}

public struct AnyUIViewControllerRepresentable: UIViewControllerRepresentable {
    private let viewController: UIViewController

    public  init(viewController: UIViewController) {
        self.viewController = viewController
    }

    public func makeUIViewController(context: Context) -> some UIViewController {
        return viewController
    }

    public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
}
