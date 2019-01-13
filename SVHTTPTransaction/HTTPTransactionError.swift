import Foundation

/// A type representing an error that occured during HTTP transaction.
///
/// - badRequest: Client failed to form a proper URL request with an error.
/// - noResponse: Server did not respond, an error occurred.
/// - notSuccess: Server did not respond with a success status code (200..<300).
/// - decodingFailure: Server did respond with a success status code (200..<300),
/// however the body is in unexpected representation.
public enum HTTPTransactionError<ProblemDetail>: Error {
    case badRequest(Error)
    case noResponse(Error)
    case notSuccess(HTTPURLResponse, ProblemDetail?)
    case decodingFailure(Error)
}
