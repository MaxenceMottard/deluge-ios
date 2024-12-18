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
    @State var viewModel: any HomeViewModel

    private let columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]

    var body: some View {
        InstanceWrapperView {
            ScrollView {
                VStack {
                    Button(action: { viewModel.presentInstanceSelector() }) {
                        ContainerView {
                            HStack {
                                if let selectedInstance = viewModel.selectedInstance {
                                    LabeledContent(
                                        String(localized: "home.label.currentInstance", bundle: .module),
                                        value: selectedInstance.name
                                    )
                                } else {
                                    Text("home.label.noInstance", bundle: .module)
                                }
                                
                                Image(systemName: "arrow.2.squarepath")
                            }
                            .padding()
                        }
                    }
                    .tint(.white)

                    if let selectedInstance = viewModel.selectedInstance {
                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.medias, id: \.id) { media in
                                HomeViewItem(
                                    media: media,
                                    onTap: { viewModel.present(media: media) }
                                )
                            }
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .task { await viewModel.fetch() }
        .onChange(of: viewModel.selectedInstance) {
            Task { await viewModel.fetch() }
        }
    }
}

#Preview {
    let viewModel: any HomeViewModel = {
        let viewModel = MockHomeViewModel()
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
