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

struct HomeView: View {
    @State var viewModel: HomeViewModel

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
                        Text(selectedInstance.url)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        LazyVGrid(columns: columns) {
                            ForEach(viewModel.series) { serie in
                                Button(action: {}) {
                                    Item(serie: serie)
                                }
                                .buttonStyle(ScalableButtonStyle())
                                .id(serie.id)
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
            await viewModel.fetchSeries()
        }
        .onChange(of: viewModel.selectedInstance) {
            Task { await viewModel.fetchSeries() }
        }
    }

    struct Item: View {
        @State private var size: CGSize = .zero

        let serie: Serie

        var body: some View {
            ViewWithRatio(ratio: 0.68) {
                LazyImage(url: URL(string: serie.poster)) { state in
                    if let image = state.image {
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                    } else if state.isLoading {
                        Color.clear
                    } else {
                        Text(serie.title)
                            .font(.body)
                            .multilineTextAlignment(.leading)
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                            .padding(8)
                            .background(.white.opacity(0.2))
                            .roundedBorder(.white.opacity(0.4), width: 1, radius: 8)
                    }
                }
                .cornerRadius(8)
            }
            .readSize($size)
        }
    }
}

//#Preview {
//    HomeView(
//        viewModel: HomeViewModel(
//            dependencies: Dependency.HomeViewModelDependencies(router: Router()),
//            instanceSelectorViewModel: InstanceSelectorViewModel(
//                dependencies: Dependency.InstanceSelectorViewModelDependencies(router: Router())
//            )
//        )
//    )
//}
