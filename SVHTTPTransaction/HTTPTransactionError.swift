import Foundation

/// A type representing an error that occured during HTTP transaction.
///
/// - badRequest: Client failed to form a proper URL request. It raises
///   when DataHTTPRequest.urlRequest() threw and the thrown error is
///   the associated value. Don't confuse it with 4xx response.
/// - noResponse: No response came from server. Underlying error is
///   the associated value.
/// - unsuccessfulRequest: Server did not respond with a success status
///   code (200..<300).
/// - decodingFailure: Server did respond with a success status code
///   (200..<300), however the body is an unexpected structure.
///   The underlying error is associated value and is raised
///   in `ResponseBody.init(data: Data) throws`.
public enum HTTPTransactionError<ProblemDetail>: Error {
    case badRequest(Error)
    case noResponse(Error)
    case unsuccessfulRequest(HTTPURLResponse, ProblemDetail?)
    case decodingFailure(Error)
}
