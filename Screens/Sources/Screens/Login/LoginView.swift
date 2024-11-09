//
//  LoginView.swift
//  Deluge
//
//  Created by Maxence Mottard on 28/10/2024.
//

import SwiftUI
import Routing

struct LoginView: View {
    @State var viewModel: LoginViewModel

    var body: some View {
        VStack {
            TextField("Server Url", text: $viewModel.serverUrl)
                .textContentType(.URL)
            TextField("Api Key", text: $viewModel.apiKey)
                .textContentType(.username)

            Button("Login") {
                Task { await viewModel.login() }
            }
        }
    }
}

//#Preview {
//    LoginView(
//        viewModel: LoginViewModel(
//            dependencies: Dependency.loginViewModelDependencies(router: Router())
//        )
//    )
//}

