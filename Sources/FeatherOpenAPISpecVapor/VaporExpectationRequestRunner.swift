//
//  VaporExpectationRequestRunner.swift
//  FeatherOpenAPISpecVapor
//
//  Created by Tibor Bödecs on 23/11/2023.
//

import OpenAPIRuntime
import HTTPTypes
import Vapor
import FeatherOpenAPISpec
import XCTVapor

public struct VaporExpectationRequestRunner: SpecRunner {

    let app: Application

    public init(
        app: Application
    ) {
        self.app = app
    }

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
            try await body.collect(upTo: value, into: &reqBuffer)
        case .unknown:
            for try await chunk in body {
                reqBuffer.writeBytes(chunk)
            }
        }

        var result: (response: HTTPResponse, body: HTTPBody)!

        try app.test(
            .init(req.method),
            req.path ?? "",
            headers: .init(req.headerFields),
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
                    headerFields: .init(res.headers)
                )
                let body = HTTPBody(.init(buffer: res.body))
                result = (response: response, body: body)
            }
        )
        return result
    }
}
