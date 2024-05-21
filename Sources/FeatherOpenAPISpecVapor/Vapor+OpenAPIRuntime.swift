//
//  Vapor+OpenAPIRuntime.swift
//  FeatherSpecVapor
//
//  Created by Tibor Bödecs on 23/11/2023.
//

import OpenAPIRuntime
import HTTPTypes
import NIOHTTP1

extension HTTPTypes.HTTPFields {
    /// Initializes `HTTPTypes.HTTPFields` from `NIOHTTP1.HTTPHeaders`.
    ///
    /// - Parameter headers: The `NIOHTTP1.HTTPHeaders` instance to convert.
    init(_ headers: NIOHTTP1.HTTPHeaders) {
        self.init(
            headers.compactMap { name, value in
                guard let name = HTTPField.Name(name) else {
                    return nil
                }
                return HTTPField(name: name, value: value)
            }
        )
    }
}

extension NIOHTTP1.HTTPHeaders {
    /// Initializes `NIOHTTP1.HTTPHeaders` from `HTTPTypes.HTTPFields`.
    ///
    /// - Parameter headers: The `HTTPTypes.HTTPFields` instance to convert.
    init(_ headers: HTTPTypes.HTTPFields) {
        self.init(headers.map { ($0.name.rawName, $0.value) })
    }
}

extension NIOHTTP1.HTTPMethod {
    /// Initializes `NIOHTTP1.HTTPMethod` from `HTTPTypes.HTTPRequest.Method`.
    ///
    /// - Parameter method: The `HTTPTypes.HTTPRequest.Method` instance to convert.
    init(_ method: HTTPTypes.HTTPRequest.Method) {
        switch method {
        case .get: self = .GET
        case .put: self = .PUT
        case .post: self = .POST
        case .delete: self = .DELETE
        case .options: self = .OPTIONS
        case .head: self = .HEAD
        case .patch: self = .PATCH
        case .trace: self = .TRACE
        default: self = .RAW(value: method.rawValue)
        }
    }
}
