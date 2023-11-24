import Foundation
import XCTest
import OpenAPIRuntime
import HTTPTypes
import FeatherOpenAPISpec
import FeatherOpenAPISpecRunnerVapor
import Vapor

enum SomeError: Error {
    case foo
}

struct Todo: Codable {
    let title: String
}

extension Todo: Content {}

final class FeatherOpenAPISpecRunnerVaporTests: XCTestCase {

    func other() async throws {
        throw SomeError.foo
    }

    func testVapor() async throws {
        let app = Application(.testing)
        defer { app.shutdown() }

        app.routes.post("todos") { req async throws -> Todo in
            try req.content.decode(Todo.self)
        }
        let runner = VaporExpectationRequestRunner(app: app)
        try await test(using: runner)
    }

    func test(using runner: SpecRunner) async throws {
        let encoder = JSONEncoder()
        var buffer = ByteBuffer()
        try encoder.encode(Todo(title: "task01"), into: &buffer)
        let body = HTTPBody(.init(buffer: buffer))

        try await SpecBuilder {
            Method(.post)
            Path("todos")
            Header(.contentType, "application/json")
            Body(body)
            Expectation(.ok)
            Expectation { response, body in
                var buffer = ByteBuffer()
                switch body.length {
                case .known(let value):
                    try await body.collect(upTo: value, into: &buffer)
                case .unknown:
                    for try await chunk in body {
                        buffer.writeBytes(chunk)
                    }
                }
                let decoder = JSONDecoder()
                let todo = try decoder.decode(Todo.self, from: buffer)
                XCTAssertEqual(todo.title, "task01")
            }
        }
        .build(using: runner)
        .test()

        var spec = Spec(runner: runner)
        spec.setMethod(.post)
        spec.setPath("todos")
        spec.setBody(body)
        spec.setHeader(.contentType, "application/json")
        spec.addExpectation(.ok)
        spec.addExpectation { response, body in
            /// same as above...
        }
        try await spec.test()

        try await Spec(runner: runner)
            .post("todos")
            .header(.contentType, "application/json")
            .body(body)
            .expect(.ok)
            .expect { response, body in
                // some expectation...
            }
            .test()
    }
}
