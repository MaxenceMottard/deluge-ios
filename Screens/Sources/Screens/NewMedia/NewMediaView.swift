//
//  NewMediaView.swift
//  Screens
//
//  Created by Maxence Mottard on 27/11/2024.
//

import SwiftUI
import Routing

struct NewMediaView: View {
    @State var viewModel: any NewMediaViewModel

    var body: some View {
        Form {
            Picker(String(localized: "newMedia.field.rootFolder", bundle: .module), selection: $viewModel.selectedRootFolder) {
                ForEach(viewModel.rootFolders, id: \.self) { folder in
                    Text(folder.path)
                }
            }
        }
        .onAppear {
            viewModel.selectedRootFolder = viewModel.rootFolders.first
        }
    }
}

#Preview {
    let viewModel: NewMediaViewModel = {
        let viewModel = MockNewMediaViewModel()

        return viewModel
    }()

    NewMediaView(viewModel: viewModel)
}
