import Foundation

/// A type representing an error that occured during HTTP transaction.
public enum HTTPTransactionError<ProblemDetail>: Error {
    case noResponse(Error)
    case badResponse(HTTPURLResponse, ProblemDetail?)
    case decodingFailure(Error)
}
