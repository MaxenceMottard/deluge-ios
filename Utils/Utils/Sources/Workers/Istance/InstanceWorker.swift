//
//  InstanceWorker.swift
//  Utils
//
//  Created by Maxence Mottard on 06/11/2024.
//

import Foundation
import Combine

@Observable
public class InstanceWorker: InstanceWorking {
    private enum Constants {
        static let instancesKey = "instances"
        static let selectedInstanceKey = "selected-instance"
    }

    private let keychainWorker: KeychainWorking
    private var cancellables = Set<AnyCancellable>()

    public var instances = Instances() {
        didSet { update(instances: instances) }
    }
    public var selectedInstance: Instance? {
        didSet { update(instances: instances) }
    }

    public init(keychainWorker: KeychainWorking) {
        self.keychainWorker = keychainWorker
        initvalue()
    }

    private func update(instances: Instances) {
        let isSaved = keychainWorker.save(for: Constants.instancesKey, value: instances)
        guard isSaved else { return }
    }

    private func update(selectedInstance newValue: Instance?) {
        keychainWorker.save(for: Constants.selectedInstanceKey, value: newValue)
    }

    public func remove(instance: Instance) {
        instances.remove(instance)
    }

    public func select(instance newSelectedInstance: Instance) {
        selectedInstance = newSelectedInstance
        keychainWorker.save(for: Constants.selectedInstanceKey, value: newSelectedInstance)
    }

//    public func observe<Value>(apply: @escaping () -> Value, execute: @escaping (Value) -> Void) {
//        let value = withObservationTracking {
//            apply()
//        } onChange: {
//            Task { [weak self] in
//                self?.observe(apply: apply, execute: execute)
//            }
//        }
//
//        execute(value)
//    }

    // MARK: Private methods

    private func initvalue() {
        let instances = keychainWorker.retrieve(for: Constants.instancesKey, type: Instances.self)
        let selectedInstance = keychainWorker.retrieve(for: Constants.selectedInstanceKey, type: Instance.self)

        if let instances { self.instances = instances }
        if let selectedInstance { self.selectedInstance = selectedInstance }
    }
}
