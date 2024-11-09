//
//  View+Extensions.swift
//  Utils
//
//  Created by Maxence Mottard on 06/11/2024.
//

import SwiftUI

extension View {
    public func viewController(
        title: String,
        largeTitleDisplayMode: UINavigationItem.LargeTitleDisplayMode
    ) -> UIViewController {
        let controller = HostingController(rootView: self)
        controller.navigationItem.largeTitleDisplayMode = largeTitleDisplayMode
        controller.title = title
        return controller
    }
}

private class HostingController<C: View>: UIHostingController<AnyView> {
    init(rootView: C) {
        super.init(rootView: AnyView(rootView.navigationBarBackButtonHidden(true)))
    }

    @MainActor required dynamic init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewWillAppear(_ animated: Bool) {
        self.navigationItem.hidesBackButton = true
        super.viewWillAppear(animated)
    }
}
