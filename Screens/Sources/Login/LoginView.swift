//
//  LoginView.swift
//  Deluge
//
//  Created by Maxence Mottard on 28/10/2024.
//

import SwiftUI

struct LoginView: View {
    @State var viewModel: LoginViewModel

    var body: some View {
        VStack {
            TextField("Server Url", text: $viewModel.serverUrl)
            TextField("Username", text: $viewModel.username)
            SecureField("Password", text: $viewModel.password)

            Button("Login") {
                Task { await viewModel.login() }
            }
        }
    }
}
