//___FILEHEADER___

import SwiftUI
import Routing

struct ___VARIABLE_screenName:identifier___View: View {
    @State var viewModel: ___VARIABLE_screenName:identifier___ViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    ___VARIABLE_screenName:identifier___View(
        viewModel: ___VARIABLE_screenName:identifier___ViewModel(
            dependencies: ___VARIABLE_screenName:identifier___ViewModel.Dependencies(
                router: Router()
            )
        )
    )
}
