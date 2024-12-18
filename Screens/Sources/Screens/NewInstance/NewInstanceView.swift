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

    @State var viewModel: any NewInstanceViewModel
    @FocusState private var focused: Field?

    var body: some View {
        VStack {
            Form {
                Section {
                    Picker(String(localized: "newInstance.field.instanceType", bundle: .module), selection: $viewModel.type) {
                        ForEach(Instance.InstanceType.allCases) {
                            Text(String(describing: $0).capitalized)
                        }
                    }
                }

                Section(
                    content: {
                        TextField(String(localized: "newInstance.field.name", bundle: .module), text: $viewModel.name)
                            .autocorrectionDisabled()
                            .focused($focused, equals: .name)
                            .onSubmit { focused = .url }

                        TextField(String(localized: "newInstance.field.url", bundle: .module), text: $viewModel.url)
                            .textContentType(.URL)
                            .keyboardType(.URL)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                            .focused($focused, equals: .url)
                            .onSubmit { focused = .apiKey }
                    },
                    header: {
                        Text("newInstance.section.instance", bundle: .module)
                    },
                    footer: {
                        VStack(alignment: .leading, spacing: 0) {
                            Text("newInstance.label.urlHelp", bundle: .module)
                            Text("newInstance.label.urlSample", bundle: .module)
                                .tint(.white)
                                .disabled(true)
                        }
                        .font(.footnote)
                    }
                )

                Section {
                    TextField(String(localized: "newInstance.field.apiKey", bundle: .module), text: $viewModel.apiKey)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .focused($focused, equals: .apiKey)
                        .onSubmit { submitForm() }
                } footer: {
                    Text("newInstance.label.apiKeyHelp", bundle: .module)
                        .font(.footnote)
                }
            }
            Spacer()

            Button(String(localized: "newInstance.button.connect", bundle: .module).uppercased()) {
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
    let viewModel: any NewInstanceViewModel = {
        let viewModel = MockNewInstanceViewModel()
        viewModel.name = ""
        viewModel.url = ""
        viewModel.apiKey = ""
        viewModel.type = .sonarr
        viewModel.isFormValid = true

        return viewModel
    }()

    NewInstanceView(viewModel: viewModel)
}
