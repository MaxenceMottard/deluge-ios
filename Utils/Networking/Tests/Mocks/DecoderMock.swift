//
//  DecoderMock.swift
//  Utils
//
//  Created by Maxence Mottard on 06/11/2024.
//

import Foundation
@testable import Networking

class DecoderMock: Networking.Decoder {

    //MARK: - decode<T>

    var decodeFromThrowableError: Error?
    var decodeFromCallsCount = 0
    var decodeFromCalled: Bool {
        return decodeFromCallsCount > 0
    }
    var decodeFromReceivedArguments: (type: Any.Type, data: Data)?
    var decodeFromReceivedInvocations: [(type: Any.Type, data: Data)] = []
    var decodeFromReturnValue: Any!
    var decodeFromClosure: ((Any.Type, Data) throws -> Any.Type)?

    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable {
        if let error = decodeFromThrowableError {
            throw error
        }
        decodeFromCallsCount += 1
        decodeFromReceivedArguments = (type: type, data: data)
        decodeFromReceivedInvocations.append((type: type, data: data))
        if let decodeFromClosure = decodeFromClosure {
            return try decodeFromClosure(type, data) as! T
        } else {
            return decodeFromReturnValue as! T
        }
    }

}
