//
//  KeychainWorker.swift
//  Utils
//
//  Created by Maxence Mottard on 06/11/2024.
//

import Foundation

public class KeychainWorker: KeychainWorking {
    private let jsonDecoder = JSONDecoder()
    private let jsonEncoder = JSONEncoder()

    public enum Error: Swift.Error {
        case save
        case load
        case delete
    }

    public init() {}

    @discardableResult
    public func save(for key: String, data: Data) -> Bool {
        // Delete any existing item
        let queryDelete = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        SecItemDelete(queryDelete)

        // Add new item
        let queryAdd = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecValueData: data
        ] as CFDictionary

        let status = SecItemAdd(queryAdd, nil)
        return status == errSecSuccess
    }

    @discardableResult
    public func save<E>(for key: String, value: E) -> Bool where E: Encodable {
        guard let data = try? jsonEncoder.encode(value) else { return false }
        return save(for: key, data: data)
    }

    public func retrieve(for key: String) -> Data? {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key,
            kSecReturnData: true,
            kSecMatchLimit: kSecMatchLimitOne
        ] as CFDictionary

        var result: AnyObject?
        let status = SecItemCopyMatching(query, &result)

        guard status == errSecSuccess, let data = result as? Data else {
            return nil
        }

        return data
    }

    public func retrieve<D>(for key: String, type: D.Type) -> D? where D : Decodable {
        guard let data = retrieve(for: key) else { return nil }
        return try? jsonDecoder.decode(type, from: data)
    }

    @discardableResult
    public func delete(for key: String) -> Bool {
        let query = [
            kSecClass: kSecClassGenericPassword,
            kSecAttrAccount: key
        ] as CFDictionary

        let status = SecItemDelete(query)
        return status == errSecSuccess
    }

}
