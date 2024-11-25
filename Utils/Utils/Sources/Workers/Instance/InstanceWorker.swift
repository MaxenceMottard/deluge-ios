//
//  InstanceWorker.swift
//  Utils
//
//  Created by Maxence Mottard on 06/11/2024.
//

import Foundation
import Combine

@Observable
class InstanceWorker: InstanceWorking {
    private enum Constants {
        static let instancesKey = "instances"
        static let selectedInstanceKey = "selected-instance"
    }

    private let keychainWorker: KeychainWorking
    private var cancellables = Set<AnyCancellable>()

    var instances = Instances() {
        didSet { update(instances: instances) }
    }
    var selectedInstance: Instance? {
        didSet { update(selectedInstance: selectedInstance) }
    }

    init(keychainWorker: KeychainWorking) {
        self.keychainWorker = keychainWorker
        initvalue()
    }

    func update(instances: Instances) {
        let isSaved = keychainWorker.save(for: Constants.instancesKey, value: instances)
        guard isSaved else { return }
    }

    private func update(selectedInstance newValue: Instance?) {
        keychainWorker.save(for: Constants.selectedInstanceKey, value: newValue)
    }

    func remove(instance: Instance) {
        instances.remove(instance)
    }

    func select(instance newSelectedInstance: Instance) {
        selectedInstance = newSelectedInstance
        keychainWorker.save(for: Constants.selectedInstanceKey, value: newSelectedInstance)
    }

    // MARK: Private methods

    private func initvalue() {
        let instances = keychainWorker.retrieve(for: Constants.instancesKey, type: Instances.self)
        let selectedInstance = keychainWorker.retrieve(for: Constants.selectedInstanceKey, type: Instance.self)
        if let instances { self.instances = instances }
        if let selectedInstance { self.selectedInstance = selectedInstance }
    }
}
