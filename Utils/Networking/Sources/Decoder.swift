//
//  Decoder.swift
//  Utils
//
//  Created by Maxence Mottard on 06/11/2024.
//

import Foundation

protocol Decoder {
    func decode<T>(_ type: T.Type, from data: Data) throws -> T where T: Decodable
}

extension JSONDecoder: Decoder {}
