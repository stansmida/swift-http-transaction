import Foundation

/// A type that can be converted from/to data.
public protocol DataConvertible {
    init(data: Data) throws
    func data() throws -> Data
}

/// A type that represents empty data. Use where empty body is expected.
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
