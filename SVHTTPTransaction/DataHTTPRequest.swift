import Foundation

public protocol DataHTTPRequest {
    /**
     A type that represents a HTTP request.
     
     - Important: Data (body) are primarily expected in response for
     `DataHTTPRequest`.
     If response is expected to have empty HTTP message body data, you can use
     `EmptyData` type as `ResponseBody` in concrete `DataHTTPRequest` type.
     It is the most appropriate among others considered types (`Data`,
     `Optional<Data>`, Optional<Void>, `Void`). The response just technically
     has empty data - thats it.
     */
    associatedtype ResponseBody: EntityBody
    associatedtype ProblemDetail: ProblemDetailProtocol
    func urlRequest() throws -> URLRequest
    static var expectedStatusCode: Int { get }
}

public protocol RequestEntityInclusion {
    associatedtype Entity: EntityProtocol
    var entity: Entity { get }
}
