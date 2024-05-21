//
//  VaporExpectationRequestRunner.swift
//  FeatherSpecVapor
//
//  Created by Tibor Bödecs on 23/11/2023.
//

import OpenAPIRuntime
import HTTPTypes
import Vapor
import FeatherSpec
import XCTVapor

/// A custom Spec runner for Vapor applications.
public struct VaporExpectationRequestRunner: SpecRunner {

    /// The Vapor application.
    let app: Application

    /// Initializes a `VaporExpectationRequestRunner` instance with the specified Vapor application.
    ///
    /// - Parameter app: The Vapor application to use for executing requests.
    public init(
        app: Application
    ) {
        self.app = app
    }

    /// Executes an HTTP request asynchronously against the Vapor application.
    ///
    /// - Parameters:
    ///   - req: The HTTP request to execute.
    ///   - body: The HTTP request body.
    /// - Returns: A tuple containing the HTTP response and response body.
    public func execute(
        req: HTTPRequest,
        body: HTTPBody
    ) async throws -> (
        response: HTTPResponse,
        body: HTTPBody
    ) {
        var reqBuffer = ByteBuffer()
        switch body.length {
        case .known(let value):
            try await body.collect(upTo: Int(value), into: &reqBuffer)
        case .unknown:
            for try await chunk in body {
                reqBuffer.writeBytes(chunk)
            }
        }

        var result: (response: HTTPResponse, body: HTTPBody)!
        try app.test(
            .init(rawValue: req.method.rawValue),
            req.path ?? "",
            headers: .init(req.headerFields.toHTTPHeaders()),
            body: reqBuffer,
            file: #file,
            line: #line,
            beforeRequest: { _ in },
            afterResponse: { res in
                let response = HTTPResponse(
                    status: .init(
                        code: Int(res.status.code),
                        reasonPhrase: res.status.reasonPhrase
                    ),
                    headerFields: .init(res.headers.toHTTPFields())
                )
                let body = HTTPBody(.init(buffer: res.body))
                result = (response: response, body: body)
            }
        )
        return result
    }
}

extension HTTPFields {
    /// Converts `HTTPFields` to an array of header key-value pairs.
    func toHTTPHeaders() -> [(String, String)] {
        var headers = [(String, String)]()
        for index in self.indices {
            headers.append((self[index].name.rawName, self[index].value))
        }
        return headers
    }
}

extension HTTPHeaders {
    /// Converts `HTTPHeaders` to `HTTPFields`.
    func toHTTPFields() -> HTTPFields {
        var fields = HTTPFields()
        for index in self.indices {
            fields.append(
                HTTPField(
                    name: HTTPField.Name(self[index].name)!,
                    value: self[index].value
                )
            )
        }
        return fields
    }
}
