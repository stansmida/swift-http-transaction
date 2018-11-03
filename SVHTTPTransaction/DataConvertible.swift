import Foundation

/// A type that can be converted from/to data.
public protocol DataConvertible {
    init(data: Data) throws
    func data() throws -> Data
}
