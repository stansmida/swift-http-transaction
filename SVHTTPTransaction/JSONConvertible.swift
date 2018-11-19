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
        return sharedJSONDecoder
    }
    
    public static var jsonEncoder: JSONEncoder {
        return sharedJSONEncoder
    }
}
private let sharedJSONDecoder = JSONDecoder()
private let sharedJSONEncoder = JSONEncoder()

extension Array: JSONConvertible where Element: JSONConvertible {}
extension Array: DataConvertible where Element: JSONConvertible {}

extension Optional: JSONConvertible where Wrapped: JSONConvertible {}
extension Optional: DataConvertible where Wrapped: JSONConvertible {}
