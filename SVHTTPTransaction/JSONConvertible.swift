import Foundation

public protocol JSONConvertible: Codable, DataConvertible {
    static var jsonEncoder: JSONEncoder { get }
    static var jsonDecoder: JSONDecoder { get }
}

extension JSONConvertible {
    
    // MARK: - DataConvertible defaults
    
    public init(data: Data) throws {
        self = try Self.jsonDecoder.decode(Self.self, from: data)
    }
    
    public func data() throws -> Data {
        return try Self.jsonEncoder.encode(self)
    }
    
    // MARK: - JSONConvertible defaults
    
    public static var jsonDecoder: JSONDecoder {
        return JSONDecoder()
    }
    
    public static var jsonEncoder: JSONEncoder {
        return JSONEncoder()
    }
}

extension Array: JSONConvertible where Element: JSONConvertible {}

/// - Note: Conditional conformance of type 'Array<Element>' to protocol 'JSONConvertible' does not imply conformance to inherited protocol 'DataConvertible'. See also https://github.com/apple/swift-evolution/pull/809 and https://github.com/apple/swift/pull/15268.
extension Array: DataConvertible where Element: JSONConvertible {}
