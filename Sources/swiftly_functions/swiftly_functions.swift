
import Foundation
import Vapor

public protocol SwiftlyFunctionController {
    static func defineFunctions(context: Swiftly)
}

public class Swiftly {
    
    private var functions: [String: RequestResponseBlock] = [:]
    
    private init() {}
    
    public typealias RequestResponseBlock = (Request) throws -> ResponseRepresentable
    
    public static let shared: Swiftly = Swiftly()
    
    public func define(_ name: String, block: @escaping RequestResponseBlock) {
        self.functions[name] = block
    }
    
    public func performFunction(_ request: Request) throws -> ResponseRepresentable {
        let name = try request.parameters.next(String.self)
        
        guard let function = self.functions[name] else {
            throw Abort.badRequest
        }
        
        return try function(request)
    }
    
    public func register(controller: SwiftlyFunctionController.Type) {
        controller.defineFunctions(context: self)
    }
}
