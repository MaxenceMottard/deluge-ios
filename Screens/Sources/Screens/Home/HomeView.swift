//
//  HomeView.swift
//  Screens
//
//  Created by Maxence Mottard on 06/11/2024.
//

import SwiftUI
import Routing

struct HomeView: View {
    @State var viewModel: HomeViewModel

    var body: some View {
        InstanceWrapperView {
            VStack {
                InstanceSelectorView(viewModel: viewModel.instanceSelectorViewModel)

                Spacer()
            }
        }
        .task { await viewModel.fetchSeries() }
        .onChange(of: viewModel.selectedInstance) {
            Task { await viewModel.fetchSeries() }
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
