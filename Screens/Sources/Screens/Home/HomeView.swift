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
                        LabeledContent("Instance", value: selectedInstance.name)

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
            VStack {
                ViewWithRatio(ratio: 0.68) {
                    LazyImage(url: URL(string: serie.poster)) { state in
                        if let image = state.image {
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        } else if state.isLoading {
                            Color.clear
                        } else {
                            ContainerView {
                                Text(serie.title)
                                    .font(.body)
                                    .multilineTextAlignment(.leading)
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
                                    .padding(8)
                            }
                        }
                    }
                    .cornerRadius(8)
                }
                .readSize($size)

                Text(serie.title)
                    .lineLimit(1)
                    .font(.caption)
                    .frame(maxWidth: .infinity, alignment: .leading)

                Text(String(serie.year))
                    .font(.caption2)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundStyle(.gray)
                    .hidden(serie.year == 0)
            }
        }
    }
}

#Preview {
    let instanceWorker: InstanceWorking = {
        let worker = InstanceWorkingMock()
        worker.selectedInstance = Instance(
            type: .sonarr,
            name: "Test",
            url: "https://test",
            apiKey: "test"
        )

        return worker
    }()

    let getSeriesWorker: GetSeriesWebWorking = {
        let worker = GetSeriesWebWorkingMock()
        worker.runReturnValue = .preview

        return worker
    }()

    HomeView(
        viewModel: HomeViewModel(
            dependencies: HomeViewModel.Dependencies(
                instanceWorker: instanceWorker,
                getSeriesWebWorker: getSeriesWorker,
                imageCacheWorker: ImageCacheWorkingMock(),
                router: Router()
            )
        )
    )
}
