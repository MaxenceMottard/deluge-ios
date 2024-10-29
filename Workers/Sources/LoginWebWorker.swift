//
//  LoginWebWorker.swift
//  Deluge
//
//  Created by Maxence Mottard on 28/10/2024.
//

import Foundation
import Networking

public struct LoginWebWorker {
    public struct Body: Encodable, Sendable {
        private let username: String
        private let password: String
        private let rememberMe: String = "on"

        public init(username: String, password: String) {
            self.username = username
            self.password = password
        }
    }

    public init() {}

    public func run(serverURL: String, body: Body) async throws {
        try await Request()
            .set(method: .POST)
            .set(url: serverURL)
            .set(path: "/login")
            .set(queryParameter: "returnUrl", value: "no-url")
            .set(contentType: .json)
            .set(body: body)
            .set(responseType: Void.self)
            .run()
    }
}
