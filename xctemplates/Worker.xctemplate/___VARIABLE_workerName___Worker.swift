//___FILEHEADER___

import Networking

// sourcery: AutoMockable
public protocol ___VARIABLE_workerName:identifier___Working: Sendable {
    func run() async throws
}

struct ___VARIABLE_workerName:identifier___Worker: ___VARIABLE_workerName:identifier___Working {
    func run() async throws {
        try await Request()
            .set(method: <#T##Networking.Method#>)
            .set(path: "/api/v3/<#T##String#>")
            .set(contentType: <#T##.json#>)
            .set(interceptor: InstanceInteceptor())
            .run()
    }
}