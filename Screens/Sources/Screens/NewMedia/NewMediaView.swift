//
//  NewMediaView.swift
//  Screens
//
//  Created by Maxence Mottard on 27/11/2024.
//

import SwiftUI
import Routing
import Workers

struct NewMediaView: View {
    @State var viewModel: any NewMediaViewModel

    var body: some View {
        VStack {
            Form {
                Section() {
                    Picker(
                        String(localized: "newMedia.field.rootFolder", bundle: .module),
                        selection: $viewModel.selectedRootFolder
                    ) {
                        ForEach(viewModel.rootFolders) { folder in
                            Text(
                                "newMedia.values.rootFolder \(folder.path) \(folder.freeSpace.toGigabytes().toString(numberOfDecimals: 1))",
                                bundle: .module
                            )
                            .tag(folder)
                        }
                    }

                    Picker(
                        String(localized: "newMedia.field.monitor", bundle: .module),
                        selection: $viewModel.selectedMonitorType
                    ) {
                        ForEach(SerieMonitor.allCases, id: \.rawValue) { type in
                            Text(type.localized, bundle: .module)
                                .tag(type)
                        }
                    }

                    Picker(
                        String(localized: "newMedia.field.quality", bundle: .module),
                        selection: $viewModel.selectedQualityProfile
                    ) {
                        ForEach(viewModel.qualityProfiles) { profile in
                            Text(profile.name)
                                .tag(profile)
                        }
                    }

                    Picker(
                        String(localized: "newMedia.field.serieType", bundle: .module),
                        selection: $viewModel.selectedSerieType
                    ) {
                        ForEach(SerieType.allCases, id: \.rawValue) { type in
                            Text(type.localized, bundle: .module)
                                .tag(type)
                        }
                    }

                    Toggle(
                        String(localized: "newMedia.field.seasonFolder", bundle: .module),
                        isOn: $viewModel.isSeasonFolderOn
                    )

                    TextField(
                        String(localized: "newMedia.field.tags", bundle: .module),
                        text: $viewModel.tagsTextfield
                    )
                    .disabled(true)
                }

                Section() {
                    Toggle(
                        String(localized: "newMedia.field.searchMissing", bundle: .module),
                        isOn: $viewModel.searchForMissingEpisodes
                    )

                    Toggle(
                        String(localized: "newMedia.field.searchCutoffUnmet", bundle: .module),
                        isOn: $viewModel.searchForCutoffUnmetEpisodes
                    )
                }
            }

            Button {
                Task {
                    await viewModel.addMedia()
                }
            } label: {
                Text("newMedia.button.add \(viewModel.searchResult.title)", bundle: .module)
                    .lineLimit(1)
            }
            .buttonStyle(.basic)
            .padding(.horizontal)
        }
        .onAppear {
            viewModel.selectedRootFolder = viewModel.rootFolders.first
            viewModel.selectedQualityProfile = viewModel.qualityProfiles.first
        }
    }
}

#Preview {
    let viewModel: NewMediaViewModel = {
        let viewModel = MockNewMediaViewModel()
        viewModel.rootFolders = .preview
        viewModel.qualityProfiles = .preview
        viewModel.isSeasonFolderOn = true
        viewModel.searchForMissingEpisodes = true
        viewModel.searchForCutoffUnmetEpisodes = false
        viewModel.tagsTextfield = ""
        viewModel.searchResult = .preview()
        viewModel.selectedMonitorType = .existing
        viewModel.selectedSerieType = .standard

        return viewModel
    }()

    NewMediaView(viewModel: viewModel)
}

private extension SerieMonitor {
    var localized: LocalizedStringKey {
        switch self {
        case .all:
            "newMedia.values.monitor.all"
        case .existing:
            "newMedia.values.monitor.existing"
        case .firstSeason:
            "newMedia.values.monitor.firstSeason"
        case .future:
            "newMedia.values.monitor.future"
        case .lastSeason:
            "newMedia.values.monitor.lastSeason"
        case .missing:
            "newMedia.values.monitor.missing"
        case .monitorSpecials:
            "newMedia.values.monitor.monitorSpecials"
        case .none:
            "newMedia.values.monitor.none"
        case .pilot:
            "newMedia.values.monitor.pilot"
        case .recent:
            "newMedia.values.monitor.recent"
        case .unmonitorSpecials:
            "newMedia.values.monitor.unmonitorSpecials"
        }
    }
}

public extension SerieType {
    var localized: LocalizedStringKey {
        switch self {
        case .standard:
            "newMedia.values.serieType.standard"
        case .anime:
            "newMedia.values.serieType.anime"
        case .daily:
            "newMedia.values.serieType.daily"
        }
    }
}
