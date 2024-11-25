//___FILEHEADER___

import Routing
import Foundation

@MainActor
// sourcery: AutoMockable
protocol ___VARIABLE_screenName:identifier___ViewModeling {

}

@Observable
@MainActor
class ___VARIABLE_screenName:identifier___ViewModel: ___VARIABLE_screenName:identifier___ViewModeling {
    struct Dependencies {
        let router: Routing
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

}
