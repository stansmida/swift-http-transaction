import Foundation

public protocol JSONConvertible: Codable, DataConvertible {
    /// Use to customize decoding.
    static var jsonEncoder: JSONEncoder { get }
    /// Use to customize decoding. Default has `keyDecodingStrategy` set to `.convertFromSnakeCase`.
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
        return sharedJSONDecoder
    }
    
    public static var jsonEncoder: JSONEncoder {
        return sharedJSONEncoder
    }
}

// MARK: - Shared default coders for `JSONConvertible` types.
// Covenient, shared yet thread safe.

private let sharedJSONDecoder: JSONDecoder = {
    let decoder = JSONDecoder()
    decoder.keyDecodingStrategy = .convertFromSnakeCase
    return decoder
}()

private let sharedJSONEncoder: JSONEncoder = {
    let encoder = JSONEncoder()
    return encoder
}()

extension Array: JSONConvertible where Element: JSONConvertible {}

/// - Note: Conditional conformance of type 'Array<Element>' to protocol 'JSONConvertible' does not imply conformance to inherited protocol 'DataConvertible'. See also https://github.com/apple/swift-evolution/pull/809 and https://github.com/apple/swift/pull/15268.
extension Array: DataConvertible where Element: JSONConvertible {}
