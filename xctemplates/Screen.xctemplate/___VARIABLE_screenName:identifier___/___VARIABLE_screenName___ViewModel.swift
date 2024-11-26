//___FILEHEADER___

import Routing
import Foundation

@MainActor
// sourcery: AutoMockable
protocol ___VARIABLE_screenName:identifier___ViewModel {

}

@Observable
@MainActor
class Default___VARIABLE_screenName:identifier___ViewModel: ___VARIABLE_screenName:identifier___ViewModel {
    struct Dependencies {
        let router: Routing
    }

    private let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

}
