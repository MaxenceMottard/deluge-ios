//
//  HomeView.swift
//  Screens
//
//  Created by Maxence Mottard on 06/11/2024.
//

import SwiftUI
import Routing
import NukeUI
import Workers
import Utils

struct HomeView: View {
    @State var viewModel: any HomeViewModeling

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        InstanceWrapperView {
            ScrollView {
                if let selectedInstance = viewModel.selectedInstance {
                    VStack {
                        LabeledContent("Instance", value: selectedInstance.name)

                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.medias, id: \.id) { media in
                                HomeViewItem(
                                    media: media,
                                    onTap: { viewModel.present(media: media) }
                                )
                            }
                        }
                    }
                    .padding(.horizontal)

                } else {
                    Text("No instance selected")
                }
            }
        }
        .task {
            await viewModel.fetchMedias()
        }
        .onChange(of: viewModel.selectedInstance) {
            Task { await viewModel.fetchMedias() }
        }
    }
}

#Preview {
    let viewModel: any HomeViewModeling = {
        let viewModel = HomeViewModelingMock()
        viewModel.medias = [Serie].preview
        viewModel.selectedInstance = Instance(
            type: .sonarr,
            name: "Test",
            url: "https://test",
            apiKey: "test"
        )
        
        return viewModel
    }()
    
    HomeView(viewModel: viewModel)
}
