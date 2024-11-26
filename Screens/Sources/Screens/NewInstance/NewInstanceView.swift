//
//  NewInstanceView.swift
//  Deluge
//
//  Created by Maxence Mottard on 28/10/2024.
//

import SwiftUI
import Routing
import Workers
import Utils
import DesignSystem

struct NewInstanceView: View {
    private enum Field: Hashable {
        case name
        case url
        case apiKey
    }

    @State var viewModel: any NewInstanceViewModeling
    @FocusState private var focused: Field?

    var body: some View {
        VStack {
            Form {
                Section {
                    Picker("newInstance.field.instanceType", selection: $viewModel.type) {
                        ForEach(Instance.InstanceType.allCases) {
                            Text(String(describing: $0).capitalized)
                        }
                    }
                }

                Section(
                    content: {
                        TextField("newInstance.field.name", text: $viewModel.name)
                            .autocorrectionDisabled()
                            .focused($focused, equals: .name)
                            .onSubmit { focused = .url }

                        TextField("newInstance.field.url", text: $viewModel.url)
                            .textContentType(.URL)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .focused($focused, equals: .url)
                            .onSubmit { focused = .apiKey }
                    },
                    header: {
                        Text("Instance")
                    },
                    footer: {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("newInstance.label.urlHelp")
                            Text("newInstance.label.urlSample")
                                .tint(.white)
                                .disabled(true)
                        }
                        .font(.footnote)
                    }
                )

                Section {
                    TextField("newInstance.field.apiKey", text: $viewModel.apiKey)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .focused($focused, equals: .apiKey)
                        .onSubmit { submitForm() }
                } footer: {
                    Text("newInstance.label.apiKeyHelp")
                        .font(.footnote)
                }
            }
            Spacer()

            Button("newInstance.button.connect".uppercased()) {
                submitForm()
            }
            .disabled(!viewModel.isFormValid)
            .buttonStyle(.basic)
            .padding()
        }
    }

    private func submitForm() {
        focused = nil
        Task { await viewModel.login() }
    }
}

#Preview {
    let viewModel: any NewInstanceViewModeling = {
        let viewModel = NewInstanceViewModelingMock()
        viewModel.name = ""
        viewModel.url = ""
        viewModel.apiKey = ""
        viewModel.type = .sonarr
        viewModel.isFormValid = true

        return viewModel
    }()

    NewInstanceView(viewModel: viewModel)
}
