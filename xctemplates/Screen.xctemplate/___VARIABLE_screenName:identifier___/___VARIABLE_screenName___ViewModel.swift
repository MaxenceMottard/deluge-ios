//___FILEHEADER___

import Routing
import Foundation

@Observable
@MainActor
class ___VARIABLE_screenName:identifier___ViewModel {
    struct Dependencies {
        let router: Routing
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

}
