//
//  InstanceSelectorView.swift
//  Screens
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Foundation
import Routing
import SwiftUI
import Utils
import Workers

struct InstanceSelectorView: View {
    @State var viewModel: InstanceSelectorViewModel

    var body: some View {
        VStack {
            ForEach(viewModel.instances) { instance in
                Button(action: { viewModel.selectedInstance = instance }) {
                    Item(
                        instance: instance,
                        status: viewModel.status(for: instance),
                        onRemoveTap: { viewModel.remove(instance: instance) }
                    )
                }
                .padding(.leading, instance == viewModel.selectedInstance ? 20 : 0)
            }

            Spacer()

            Button("Add instance") {
                viewModel.addInstance()
            }
            .buttonStyle(.basic)
        }
        .animation(.easeInOut, value: viewModel.selectedInstance)
        .padding()
        .task { await viewModel.fetchInstanceSatus() }
        .onChange(of: viewModel.instances) {
            Task { await viewModel.fetchInstanceSatus() }
        }
    }

    private struct Item: View {
        let instance: Instance
        let status: InstanceSelectorViewModel.InstanceStatus?
        let onRemoveTap: () -> Void

        private var statusColor: Color {
            switch status?.status {
            case .fail:
                .red
            case .succeed:
                .green
            case nil:
                .gray
            }
        }

        var body: some View {
            ContainerView {
                HStack(alignment: .top) {
                    VStack(alignment: .leading) {
                        HStack(alignment: .top) {
                            VStack(alignment: .leading) {
                                Text(String(describing: instance.type).capitalized)
                                    .font(.caption)
                                    .foregroundStyle(.gray)

                                Text(instance.name)
                                    .foregroundStyle(.white)
                            }

                            Spacer()

                            Circle()
                                .frame(width: 10, height: 10)
                                .foregroundStyle(statusColor)
                        }

                        LabeledContent("URL", value: instance.url)
                            .lineLimit(1)

                        LabeledContent("Version", value: status?.system?.version ?? "")
                            .lineLimit(1)

                    }

                    Menu {
                        Button(action: { onRemoveTap() }) {
                            Text("Remove")
                            Image(systemName: "trash")
                                .foregroundStyle(.red)
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .padding(.vertical, 2)
                            .padding(.leading)
                    }

                }
                .padding()
                .tint(.white)
            }
        }
    }
}

#Preview {
    let instanceWorker: InstanceWorking = {
        let worker = InstanceWorkingMock()
        worker.instances = [
            Instance(type: .sonarr, name: "Sonarr Main", url: "https://test.com", apiKey: "123"),
            Instance(type: .radarr, name: "Radarr Recovery", url: "https://test2.com", apiKey: "124"),
        ]
        worker.selectedInstance = worker.instances.first

        return worker
    }()

    let systemStatusWebWorker: SystemStatusWebWorking = {
        let worker = SystemStatusWebWorkingMock()
        var isFirstCall = true
        worker.runInstanceUrlApiKeyClosure = { _, _ in
            if isFirstCall {
                isFirstCall = false
                return SystemStatus(version: "1.19.0")
            } else {
                throw NSError(domain: "", code: 0)
            }
        }

        return worker
    }()

    InstanceSelectorView(
        viewModel: InstanceSelectorViewModel(
            dependencies: InstanceSelectorViewModel.Dependencies(
                instanceWorker: instanceWorker,
                systemStatusWebWorker: systemStatusWebWorker,
                router: Router()
            )
        )
    )
}
