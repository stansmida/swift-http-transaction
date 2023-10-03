import Foundation

public protocol JSONConvertible: DataConvertible, Codable {
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
        return sharedJSONDecoder
    }
    
    public static var jsonEncoder: JSONEncoder {
        return sharedJSONEncoder
    }
}
private let sharedJSONDecoder = JSONDecoder()
private let sharedJSONEncoder = JSONEncoder()

// MARK: -
// TODO: Add all Swift defined types in applicable for JSON? e.g. Dictionary
// as raw representation of the value...

extension Array: JSONConvertible where Element: JSONConvertible {}
extension Array: DataConvertible where Element: JSONConvertible {}

extension Optional: JSONConvertible where Wrapped: JSONConvertible {}
extension Optional: DataConvertible where Wrapped: JSONConvertible {}
