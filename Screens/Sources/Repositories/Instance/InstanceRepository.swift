//
//  InstanceRepository.swift
//  Screens
//
//  Created by Maxence Mottard on 26/11/2024.
//

import Foundation

// sourcery: AutoMockable
public protocol InstanceRepository: AnyObject {
    typealias Instances = Set<Instance>

    var instances: Instances { get set }
    var selectedInstance: Instance? { get set }

    func remove(instance: Instance)
    func select(instance: Instance)
}
