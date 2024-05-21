import Foundation
import Vapor

struct TestStruct: Codable {
    let title: String
}

extension TestStruct: Content {}
