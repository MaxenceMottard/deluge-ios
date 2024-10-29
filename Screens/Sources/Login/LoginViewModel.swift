//
//  LoginViewModel.swift
//  Deluge
//
//  Created by Maxence Mottard on 28/10/2024.
//

@preconcurrency import Workers
import Foundation
import Routing

@Observable
@MainActor
class LoginViewModel {
    // MARK: Dependencies

    let loginWebWorker = LoginWebWorker()
    let router: Routing

    // MARK: State

    var serverUrl: String = ""
    var username: String = ""
    var password: String = ""

    // MARK: Init

    init(router: Routing) {
        self.router = router
    }

    // MARK: Methods

    func login() async {
        let body = LoginWebWorker.Body(username: username, password: password)
        do {
            try await loginWebWorker.run(serverURL: serverUrl, body: body)
            print("Success")
        } catch {
            print(error)
        }
    }
}
