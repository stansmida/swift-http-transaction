import Foundation

public protocol DataHTTPRequest {
    /**
     - Important: Data (body) are primarily expected in response for
     `DataHTTPRequest`.
     If response is expected to have empty HTTP message body data, you can use
     `EmptyData` type as `ResponseBody` in concrete `DataHTTPRequest` type.
     It is the most appropriate among others considered types (`Data`,
     `Optional<Data>`, Optional<Void>, `Void`, `Optional<Never>`, `Never`, `Null`).
     The response just technically has empty data - thats it.
     */
    associatedtype ResponseBody: DataConvertible
    associatedtype ProblemDetail: ProblemDetailProtocol
    func urlRequest() throws -> URLRequest
}
