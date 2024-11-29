//
//  GlobalDataRepository.swift
//  Screens
//
//  Created by Maxence Mottard on 26/11/2024.
//

import Networking
import Workers

// sourcery: AutoMockable
public protocol GlobalDataRepository: Sendable {
    var rootFolders: [RootFolder] { get }
    var qualityProfiles: [QualityProfile] { get }

    func fetch() async
}

class DefaultGlobalDataRepository: GlobalDataRepository, @unchecked Sendable {
    struct Dependencies {
        let getQualityProfilesWorker: GetQualityProfilesWorking
        let getRootFoldersWorker: GetRootFoldersWorking
    }

    private let dependencies: Dependencies

    var rootFolders: [RootFolder] = []
    var qualityProfiles: [QualityProfile] = []

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func fetch() async {
        await fetchRootFolders()
        await fetchQualityProfiles()
    }

    private func fetchRootFolders() async {
        do {
            rootFolders = try await dependencies.getRootFoldersWorker.run()
        } catch {
            rootFolders = []
            print(error)
        }
    }

    private func fetchQualityProfiles() async {
        do {
            qualityProfiles = try await dependencies.getQualityProfilesWorker.run()
        } catch {
            qualityProfiles = []
            print(error)
        }
    }
}
