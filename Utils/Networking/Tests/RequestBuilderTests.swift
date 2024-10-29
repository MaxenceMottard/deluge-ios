//
//  RequestBuilderTests.swift
//  Utils
//
//  Created by Maxence Mottard on 06/11/2024.
//

@testable import Networking
import Testing
import Foundation

@Suite("RequestBuilder")
struct RequestBuilderTests {

    @Suite struct Setters {
        @Test func setUrl() async throws {
            let request = Request().set(url: "https://jsonplaceholder.typicode.com/todos/1")
            #expect(request.url == "https://jsonplaceholder.typicode.com/todos/1")
        }

        @Test func setPath() async throws {
            let request = Request().set(path: "/todos/1")
            #expect(request.path == "/todos/1")
        }

        @Test func setMethod() async throws {
            let request = Request().set(method: .GET)
            #expect(request.method == .GET)
        }

        @Test func setQueryParameter() async throws {
            let request = Request()
                .set(queryParameter: "id", value: "1")
                .set(queryParameter: "second", value: "abcd")

            #expect(request.queryItems.count == 2)
            let firstItem = try #require(request.queryItems.first)
            #expect(firstItem.name == "id")
            #expect(firstItem.value == "1")
            let secondItem = try #require(request.queryItems[1])
            #expect(secondItem.name == "second")
            #expect(secondItem.value == "abcd")
        }

        @Test func setHeader() async throws {
            let request = Request().set(header: "Authorization", value: "Bearer 123")
            #expect(request.headers.count == 1)
            let firstItem = try #require(request.headers.first)
            #expect(firstItem.key == "Authorization")
            #expect(firstItem.value == "Bearer 123")
        }

        @Test func setJsonContentType() async throws {
            let request = Request().set(contentType: .json)
            #expect(request.headers.count == 1)
            let firstItem = try #require(request.headers.first)
            #expect(firstItem.key == "Content-Type")
            #expect(firstItem.value == "application/json")
        }

        @Test func setFormContentType() async throws {
            let request = Request().set(contentType: .form)
            #expect(request.headers.count == 1)
            let firstItem = try #require(request.headers.first)
            #expect(firstItem.key == "Content-Type")
            #expect(firstItem.value == "application/x-www-form-urlencoded")
        }

        @Test func setBody() async throws {
            let request = Request().set(body: ["id": 1])
            let body = try #require(request.body as? [String: Int])
            #expect(body == ["id": 1])
        }

        @Test func setResponseType() async throws {
            _ = Request().set(responseType: Int.self)
        }
    }

    @Suite struct InternalMethods {

        @Suite("generateUrlRequest") struct GenerateUrlRequest {
            @Test func generateUrlRequest() throws {
                let Request = Request()
                    .set(url: "https://jsonplaceholder.typicode.com")
                    .set(path: "/todos/1")
                    .set(method: .PATCH)
                    .set(queryParameter: "id", value: "1")
                    .set(header: "Authorization", value: "Bearer 123")
                    .set(contentType: .json)
                    .set(body: ["id": 1])

                let urlRequest = try Request.generateUrlRequest()

                #expect(urlRequest.url?.absoluteString == "https://jsonplaceholder.typicode.com/todos/1?id=1")
                #expect(urlRequest.httpMethod == "PATCH")
                #expect(urlRequest.allHTTPHeaderFields == [
                    "Authorization": "Bearer 123",
                    "Content-Type": "application/json"]
                )
                let expectedBody = try JSONEncoder().encode(["id": 1])
                #expect(urlRequest.httpBody == expectedBody)
            }

            @Test func generateUrlRequestThrowNoURL() throws {
                let request = Request()

                #expect(throws: RequestError.noURL) {
                    try request.generateUrlRequest()
                }
            }

            @Test func generateUrlRequestThrowNoMethod() throws {
                let request = Request()
                    .set(url: "https://jsonplaceholder.typicode.com")

                #expect(throws: RequestError.noMethod) {
                    try request.generateUrlRequest()
                }
            }

            @Test func generateUrlRequestThrowInvalidURL() throws {
                let request = Request()
                    .set(url: "htp://invalid url")
                    .set(method: .DELETE)

                #expect(throws: RequestError.invalidURL) {
                    try request.generateUrlRequest()
                }
            }
        }

        @Suite("performRequest") struct PerformRequest {
            @Test func performWithSuccessCode() async throws {
                let request = Request()
                let requester = RequesterMock()
                requester.dataForReturnValue = (Data(), HTTPURLResponse.ok)
                request.requester = requester
                let urLRequest = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)

                let response: Void = try await request.performRequest(request: urLRequest)
                #expect(response == ())
            }

            @Test func performWithErrorCode() async throws {
                let request = Request()
                let requester = RequesterMock()
                requester.dataForReturnValue = (Data(), HTTPURLResponse(statusCode: .badRequest))
                request.requester = requester
                let urLRequest = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)

                await #expect(throws: RequestError.http(.badRequest)) {
                    try await request.performRequest(request: urLRequest)
                }
            }

            @Test func performWithUnknownErrorCode() async throws {
                let request = Request()
                let requester = RequesterMock()
                requester.dataForReturnValue = (Data(), HTTPURLResponse(statusCode: 700))
                request.requester = requester
                let urLRequest = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)

                await #expect(throws: RequestError.httpUnknown(700)) {
                    try await request.performRequest(request: urLRequest)
                }
            }

            @Test func performWithUnknownError() async throws {
                let request = Request()
                let requester = RequesterMock()
                requester.dataForReturnValue = (Data(), URLResponse())
                request.requester = requester
                let urLRequest = URLRequest(url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!)

                await #expect(throws: RequestError.unknown) {
                    try await request.performRequest(request: urLRequest)
                }
            }

            @Test func perfomRequestWithVoidAsReponseType() async throws {
                let request = Request().set(responseType: Void.self)
                let requester = RequesterMock()
                requester.dataForReturnValue = ("Response".data(using: .utf8)!, HTTPURLResponse.ok)
                request.requester = requester
                let decoder = DecoderMock()
                request.decoder = decoder
                let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
                let urLRequest = URLRequest(url: url)

                let response: Void = try await request.performRequest(request: urLRequest)
                #expect(requester.dataForCallsCount == 1)
                #expect(requester.dataForReceivedRequest == urLRequest)
                #expect(response == ())
                #expect(decoder.decodeFromCallsCount == 0)
            }

            @Test func perfomRequestWithDataAsReponseType() async throws {
                let request = Request().set(responseType: Data.self)
                let requester = RequesterMock()
                requester.dataForReturnValue = ("Response".data(using: .utf8)!, HTTPURLResponse.ok)
                request.requester = requester
                let decoder = DecoderMock()
                request.decoder = decoder
                let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
                let urLRequest = URLRequest(url: url)

                let response = try await request.performRequest(request: urLRequest)
                #expect(requester.dataForCallsCount == 1)
                #expect(requester.dataForReceivedRequest == urLRequest)
                #expect(decoder.decodeFromCallsCount == 0)
                #expect(response == "Response".data(using: .utf8))
            }

            @Test func perfomRequestWithDecodableAsReponseType() async throws {
                let request = Request().set(responseType: TestDecodable.self)
                let requester = RequesterMock()
                requester.dataForReturnValue = ("Response".data(using: .utf8)!, HTTPURLResponse.ok)
                request.requester = requester
                let decoder = DecoderMock()
                decoder.decodeFromReturnValue = TestDecodable(id: 1)
                request.decoder = decoder
                let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
                let urLRequest = URLRequest(url: url)

                let response = try await request.performRequest(request: urLRequest)
                #expect(requester.dataForCallsCount == 1)
                #expect(requester.dataForReceivedRequest == urLRequest)
                #expect(decoder.decodeFromCallsCount == 1)
                #expect(decoder.decodeFromReceivedArguments?.data == "Response".data(using: .utf8))
                #expect(decoder.decodeFromReceivedArguments?.type == TestDecodable.self)
                #expect(response == TestDecodable(id: 1))
            }

            @Test func perfomRequestWithAnySendableAsReponseType() async throws {
                let request = Request().set(responseType: AnySendable.self)
                let requester = RequesterMock()
                requester.dataForReturnValue = ("Response".data(using: .utf8)!, HTTPURLResponse.ok)
                request.requester = requester
                let decoder = DecoderMock()
                request.decoder = decoder
                let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
                let urLRequest = URLRequest(url: url)

                await #expect(throws: RequestError.wrongResponseType(AnySendable.self)) {
                    try await request.performRequest(request: urLRequest)
                }
                #expect(requester.dataForCallsCount == 1)
                #expect(requester.dataForReceivedRequest == urLRequest)
                #expect(decoder.decodeFromCallsCount == 0)
            }
        }
    }
}

private struct TestDecodable: Decodable, Equatable {
    let id: Int
}

private struct AnySendable: Sendable {}

private extension HTTPURLResponse {
    convenience init(statusCode: StatusCode) {
        self.init(statusCode: statusCode.rawValue)
    }

    convenience init(statusCode: Int) {
        self.init(
            url: URL(string: "https://jsonplaceholder.typicode.com/todos/1")!,
            statusCode: statusCode,
            httpVersion: nil,
            headerFields: nil
        )!
    }

    static var ok: HTTPURLResponse {
        HTTPURLResponse(statusCode: .ok)
    }
}

