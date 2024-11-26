//___FILEHEADER___

import SwiftUI
import Routing

struct ___VARIABLE_screenName:identifier___View: View {
    @State var viewModel: any ___VARIABLE_screenName:identifier___ViewModel

    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    let viewModel: ___VARIABLE_screenName:identifier___ViewModel = {
        let viewModel = Mock___VARIABLE_screenName:identifier___ViewModel()

        return viewModel
    }()

    ___VARIABLE_screenName:identifier___View(viewModel: viewModel)
}
