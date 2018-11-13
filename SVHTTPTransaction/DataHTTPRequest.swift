import Foundation

public protocol DataHTTPRequest {
    /**
     A type that represents a HTTP request.
     
     - Important: Data are primarily expected in response for `DataHTTPRequest`.
     If response is expected to have empty HTTP message body data, you can use
     `EmptyData` type as `Response` in concrete `DataHTTPRequest` type.
     It is the most appropriate among others considered types (`Data`,
     `Optional<Data>`, Optional<Void>, `Void`). The response just technically
     has empty data - thats it.
     */
    associatedtype Response: DataConvertible
    associatedtype ProblemDetail: ProblemDetailProtocol
    func urlRequest() throws -> URLRequest
    static var expectedStatusCode: Int { get }
}
