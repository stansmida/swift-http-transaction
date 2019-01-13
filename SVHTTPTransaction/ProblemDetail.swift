import Foundation

/**
 A type that represents [problem detail specified by IETF](https://tools.ietf.org/html/rfc7807).
 
 - Note: You can use `EmptyData` for `ProblemDetail` if your server does not
 provide problem detail or you don't want to utilize it.
 
 - Note: From
 [API Design Guidelines](https://swift.org/documentation/api-design-guidelines/#naming):
 "If an associated type is so tightly bound to its protocol constraint that the
 protocol name is the role, avoid collision by appending Protocol to the
 protocol name:"
 ```
 protocol Sequence {
 associatedtype Iterator : IteratorProtocol
 }
 protocol IteratorProtocol { ... }
 ```
 This one is the case since it is used as `associatedtype ProblemDetail` in
 `DataHTTPRequest`.
 */
public typealias ProblemDetailProtocol = DataConvertible
