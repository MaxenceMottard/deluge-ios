//
//  SearchView.swift
//  Screens
//
//  Created by Maxence Mottard on 26/11/2024.
//

import SwiftUI
import Routing
import Workers

struct SearchView: View {
    @State var viewModel: any SearchViewModel

    var body: some View {
        if viewModel.isLoading {
            ProgressView()
                .progressViewStyle(.circular)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } else if viewModel.searchResults.isEmpty {
            VStack {
                Text("search.label.noResults.1", bundle: .module)
                Text("search.label.noResults.2", bundle: .module)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
        } else {
            ScrollView {
                VStack {
                    ForEach(viewModel.searchResults, id: \.self) { item in
                        SearchItemView(
                            item: item,
                            tapOnItem: { viewModel.add(item: item) }
                        )
                    }
                }
                .padding()
            }
        }
    }
}

#Preview {
    let viewModel: SearchViewModel = {
        let viewModel = MockSearchViewModel()
        viewModel.searchResults = .preview
        viewModel.isLoading = false

        return viewModel
    }()

    SearchView(viewModel: viewModel)
}

#Preview("SearchView - Loading") {
    let viewModel: SearchViewModel = {
        let viewModel = MockSearchViewModel()
        viewModel.isLoading = true

        return viewModel
    }()

    SearchView(viewModel: viewModel)
}
