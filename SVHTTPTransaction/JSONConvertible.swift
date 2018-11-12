import Foundation

public protocol JSONConvertible: Codable, DataConvertible {}

extension JSONConvertible {
    public init(data: Data) throws {
        self = try JSONDecoder().decode(Self.self, from: data)
    }
    
    public func data() throws -> Data {
        return try JSONEncoder().encode(self)
    }
}

extension Array: JSONConvertible where Element: JSONConvertible {}

/// - Note: Conditional conformance of type 'Array<Element>' to protocol 'JSONConvertible' does not imply conformance to inherited protocol 'DataConvertible'. See also https://github.com/apple/swift-evolution/pull/809 and https://github.com/apple/swift/pull/15268.
extension Array: DataConvertible where Element: JSONConvertible {}
