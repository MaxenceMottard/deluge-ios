//
//  InstanceInteceptor.swift
//  Workers
//
//  Created by Maxence Mottard on 08/11/2024.
//

import Networking
import Utils

struct InstanceInteceptor: Interceptor {
    private enum Constants {
        static let selectedInstanceKey = "selected-instance"
    }

    let keychainWorker: KeychainWorking = KeychainWorker()

    func intercept<Response>(request: RequestBuilder<Response>) throws -> RequestBuilder<Response> where Response : Sendable {
        guard let instance = keychainWorker.retrieve(for: Constants.selectedInstanceKey, type: Instance.self) else {
            throw Error.apiKeyNotFound
        }

        return request
            .set(header: "x-api-key", value: instance.apiKey)
            .set(url: instance.url)
    }

    enum Error: Swift.Error {
        case apiKeyNotFound
    }
}
