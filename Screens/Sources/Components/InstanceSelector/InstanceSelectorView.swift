//
//  InstanceSelectorView.swift
//  Screens
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Foundation
import Routing
import SwiftUI

struct InstanceSelectorView: View {
    @State var viewModel: InstanceSelectorViewModel

    var body: some View {
        VStack {
            ForEach(viewModel.instances) { instance in
                HStack {
                    Text(instance.url)

                    Button(action: { viewModel.remove(instance: instance) }) {
                        Image(systemName: "trash")
                    }
                }
            }

            Text("Selected instance: \(viewModel.selectedInstance?.id ?? 0)")

            Button("Add instance") {
                viewModel.addInstance()
            }
        }
    }
}

//#Preview {
//    InstanceSelectorView(
//        viewModel: InstanceSelectorViewModel(
//            dependencies: InstanceSelectorViewModel.Dependencies(
//                instanceWorker: Dependency.instanceWorker,
//                router: Router()
//            )
//        )
//    )
//}
