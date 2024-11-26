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
import DesignSystem

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
                        Button(action: { viewModel.presentInstanceSelector() }) {
                            ContainerView {
                                HStack {
                                    LabeledContent(
                                        String(localized: "home.label.currentInstance", bundle: .module),
                                        value: selectedInstance.name
                                    )
                                    Image(systemName: "arrow.2.squarepath")
                                }
                                .padding()
                            }
                        }
                        .tint(.white)

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
                    Text("home.label.noInstance", bundle: .module)
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
