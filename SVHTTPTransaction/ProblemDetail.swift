import Foundation

/**
 A type that represents [problem detail specified by IETF](https://tools.ietf.org/html/rfc7807).
 
 - Note: You can use `EmptyData` as a `ProblemDetail` if your server does not
 provide problem detail or you don't want to utilize it. Example:
 ```
 extension EmptyData: ProblemDetail {}
 ```
 */
public protocol ProblemDetail: Error, DataConvertible {}
