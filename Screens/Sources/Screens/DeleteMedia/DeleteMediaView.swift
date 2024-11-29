//
//  DeleteMediaView.swift
//  Screens
//
//  Created by Maxence Mottard on 29/11/2024.
//

import SwiftUI
import Routing

struct DeleteMediaView: View {
    @State var viewModel: any DeleteMediaViewModel

    var body: some View {
        Form {
            Toggle(isOn: $viewModel.addImportListExclusion) {
                Text("deleteMedia.fields.addImportListExclusion", bundle: .module)
            }

            Toggle(isOn: $viewModel.deleteFiles) {
                Text("deleteMedia.fields.deleteFiles", bundle: .module)
            }
        }

        Button {
            Task { await viewModel.delete() }
        } label: {
            Text("deleteMedia.button.remove", bundle: .module)
        }
        .buttonStyle(.basic)
        .padding(.horizontal)
    }
}

#Preview {
    let viewModel: DeleteMediaViewModel = {
        let viewModel = MockDeleteMediaViewModel()

        return viewModel
    }()

    DeleteMediaView(viewModel: viewModel)
}
