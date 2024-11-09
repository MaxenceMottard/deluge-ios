//
//  KeychainWorking.swift
//  Utils
//
//  Created by Maxence Mottard on 09/11/2024.
//

import Foundation

public protocol KeychainWorking {
    func retrieve(for: String) -> Data?
    func retrieve<D>(for key: String, type: D.Type) -> D? where D : Decodable
    @discardableResult func save(for: String, data: Data) -> Bool
    @discardableResult func save<E>(for: String, value: E) -> Bool where E: Encodable
    @discardableResult func delete(for key: String) -> Bool
}
