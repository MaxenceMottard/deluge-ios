//___FILEHEADER___

import Routing
import SwiftUI

extension Route {
    typealias ___VARIABLE_screenName:identifier___ = ___VARIABLE_screenName:identifier___Route
}

struct ___VARIABLE_screenName:identifier___Route: Route {
    func viewController(router: Router) -> UIViewController {
        let viewModel = ___VARIABLE_screenName:identifier___ViewModel(
            dependencies: ___VARIABLE_screenName:identifier___ViewModel.Dependencies(
                router: router
            )
        )

        let view = ___VARIABLE_screenName:identifier___View(viewModel: viewModel).environmentObject(router)
        let viewController = UIHostingController(rootView: view)
        viewController.title = /*@START_MENU_TOKEN@*/"Title"/*@END_MENU_TOKEN@*/
        viewController.navigationItem.largeTitleDisplayMode = /*@START_MENU_TOKEN@*/.never/*@END_MENU_TOKEN@*/

        return viewController
    }
}
