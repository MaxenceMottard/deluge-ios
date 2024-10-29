//
//  RequestBuilder.swift
//  Utils
//
//  Created by Maxence Mottard on 06/11/2024.
//

import Foundation

public class RequestBuilder<Response: Sendable> {
    public typealias SendableEncodable = Encodable & Sendable

    let encoder: JSONEncoder = JSONEncoder()
    var decoder: any Decoder = JSONDecoder()
    var requester: any Requester = URLSession.shared

    var method: Method?

    var url: String?
    var path: String?

    var queryItems: [URLQueryItem] = []
    var headers: [String: String] = [:]

    var body: SendableEncodable?

    init() {}

    public func set(url: String) -> Self {
        self.url = url
        return self
    }

    public func set(path: String) -> Self {
        self.path = path
        return self
    }

    public func set(queryParameter name: String, value: String) -> Self {
        queryItems.append(URLQueryItem(name: name, value: value))
        return self
    }

    public func set(header name: String, value: String) -> Self {
        headers[name] = value
        return self
    }

    public func set(contentType: ContentType) -> Self {
        return set(header: "Content-Type", value: contentType.rawValue)
    }

    public func set(method: Method) -> Self {
        self.method = method
        return self
    }

    public func set<B: SendableEncodable>(body: B) -> Self {
        self.body = body
        return self
    }

    public func set<R: Sendable>(responseType: R.Type) -> RequestBuilder<R> {
        let newBuilder = RequestBuilder<R>()
        newBuilder.url = self.url
        newBuilder.path = self.path
        newBuilder.queryItems = self.queryItems
        newBuilder.headers = self.headers
        newBuilder.method = self.method
        newBuilder.body = self.body

        return newBuilder
    }

    public func run() async throws -> Response {
        let request = try generateUrlRequest()
        let response = try await performRequest(request: request)

        return response
    }

    // MARK: Private methods

    func generateUrlRequest() throws -> URLRequest {
        guard let url else { throw RequestError.noURL }
        guard let method else { throw RequestError.noMethod }

        var components = URLComponents(string: url)
        components?.queryItems = queryItems
        components?.path = path ?? ""

        guard let finalUrl = components?.url else {
            throw RequestError.invalidURL
        }

        var request = URLRequest(url: finalUrl)
        request.httpMethod = method.rawValue

        headers.forEach { key, value in
            request.addValue(value, forHTTPHeaderField: key)
        }

        if let body = body {
            request.httpBody = try encoder.encode(body)
        }

        return request
    }

    func performRequest(request: URLRequest) async throws -> Response {
        let (data, urlReponse) = try await requester.data(for: request)

        guard let httpResponse = urlReponse as? HTTPURLResponse else {
            throw RequestError.unknown
        }

        if !StatusCode.successCodes.contains(httpResponse.statusCode) {
            if let statusCode = StatusCode(rawValue: httpResponse.statusCode) {
                throw RequestError.http(statusCode)
            } else {
                throw RequestError.httpUnknown(httpResponse.statusCode)
            }
        }

        let response: Any? = if Response.self == Data.self {
            data
        } else if let type = Response.self as? Decodable.Type {
            try decoder.decode(type, from: data)
        } else if Response.self == Void.self {
            ()
        } else {
            nil
        }

        guard let response = response as? Response else {
            throw RequestError.wrongResponseType(Response.self)
        }

        return response
    }
}
