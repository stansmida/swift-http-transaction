import Foundation

/// A type that represents empty data.
public struct EmptyData: DataConvertible {
    
    public struct NotEmpty: Error {
        public let data: Data
    }

    public init(data: Data) throws {
        guard data.isEmpty else {
            throw NotEmpty(data: data)
        }
    }
    
    public func data() throws -> Data {
        return Data()
    }
}
