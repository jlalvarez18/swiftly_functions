
import Foundation
import Vapor

public protocol SwiftlyFunctionController {
    static func defineFunctions(context: Swiftly)
}

public class Swiftly {
    
    private var functions: [String: RequestResponseBlock] = [:]
    
    public typealias RequestResponseBlock = (Request) throws -> ResponseRepresentable
    
    public init() {}
    
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
    
    public func run() throws {
        let droplet = try Droplet()
        
        droplet.post("functions", String.parameter) { (req) -> ResponseRepresentable in
            return try self.performFunction(req)
        }
        
        droplet.get("functions") { (req) -> ResponseRepresentable in
            var json = JSON()
            
            try json.set("functions", Array(self.functions.keys))
            
            return json
        }
        
        try droplet.run()
    }
}
