import XCTest
import FeatherSpec
import Vapor
@testable import FeatherSpecVapor


class FeatherSpecVaporTestCase: XCTestCase {

    var app: Application!
    var runner: SpecRunner!
        
    override func setUp() async throws {
        
        app = try await Application.make(.testing)
    
        app.routes.post("getSameObjectBack") { req async throws -> TestStruct in
            try req.content.decode(TestStruct.self)
        }
        
        app.routes.put("putObject") { req async throws -> TestStruct in
            return TestStruct(title: "updatedTitle")
        }
        
        app.routes.patch("patchObject") { req async throws -> TestStruct in
            return TestStruct(title: "patchedTitle")
        }
        
        app.routes.get("getOk") { req -> Response in
            return Response(status: .ok)
        }
        
        app.routes.get("getBadRequest") { req -> Response in
            return Response(status: .badRequest)
        }
        
        app.routes.patch("patchInternalServerError") { req -> Response in
            return Response(status: .internalServerError)
        }

        runner = VaporExpectationRequestRunner(app: app)
    }
    
    override func tearDown() async throws {
        try await app.asyncShutdown()
    }


}
