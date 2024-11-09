//
//  InstanceWorking.swift
//  Utils
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Foundation

public protocol InstanceWorking: AnyObject {
    typealias Instances = Set<Instance>

    var instances: Instances { get set }
    var selectedInstance: Instance? { get set }

    func remove(instance: Instance)
    func select(instance: Instance)
//    func observe<Value>(apply: @escaping () -> Value, execute: @escaping (Value) -> Void)
}
