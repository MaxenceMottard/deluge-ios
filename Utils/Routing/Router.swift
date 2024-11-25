//
//  Router.swift
//  fore
//
//  Created by Maxence Mottard on 25/05/2024.
//

import SwiftUI

// sourcery: AutoMockable
public protocol Routing {
    var navigationController: UINavigationController { get }
    init(dismiss: (() -> Void)?)

    func setRoot(viewController: UIViewController)
    @MainActor func present(route: any Route, modal kind: RoutingModalKind)
    @MainActor func navigate(to route: any Route)
    @MainActor func dismiss()
    @MainActor func popToRoot()
}

public enum RoutingModalKind {
    case fullScreen
    case sheet
}

@MainActor
public class Router: @preconcurrency Routing, ObservableObject {
    public typealias ModalKind = RoutingModalKind

    public let navigationController = UINavigationController()
    private let dismissAction: (() -> Void)?

    public convenience init() {
        self.init(dismiss: nil)
    }

    public required init(dismiss: (() -> Void)?) {
        dismissAction = dismiss
        navigationController.navigationBar.prefersLargeTitles = true
    }

    public func setRoot(viewController: UIViewController) {
        navigationController.viewControllers = [viewController]
    }

    @MainActor public func present(route: any Route, modal kind: ModalKind) {
        let router = Router()
        let viewController = route.viewController(router: router)
        router.setRoot(viewController: viewController)

        switch kind {
        case .fullScreen:
            viewController.modalPresentationStyle = .fullScreen
        case .sheet:
            viewController.modalPresentationStyle = .pageSheet
        }

        navigationController.present(router.navigationController, animated: true)
    }

    @MainActor public func navigate(to route: any Route) {
        let viewController = route.viewController(router: self)
        navigationController.pushViewController(viewController, animated: true)
    }

    @MainActor public func dismiss() {
        if let dismissAction, navigationController.viewControllers.count <= 1 {
            dismissAction()
        } else if navigationController.viewControllers.count <= 1 {
            navigationController.dismiss(animated: true)
        } else {
            navigationController.popViewController(animated: true)
        }
    }

    @MainActor public func popToRoot() {
        navigationController.popToRootViewController(animated: true)
    }

    @MainActor public struct View: UIViewControllerRepresentable {
        private let router: Router

        public init(dismiss: (() -> Void)?, initialRoute: any Route) {
            router = Router(dismiss: dismiss)
            router.setRoot(viewController: initialRoute.viewController(router: router))
        }

        public func makeUIViewController(context: Context) -> UINavigationController {
            return router.navigationController
        }

        public func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {}
    }
}
