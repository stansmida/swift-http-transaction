import Foundation

/// See [RFC 2616](https://www.w3.org/Protocols/rfc2616/rfc2616-sec7.html)
public typealias EntityBody = DataConvertible

/// See [RFC 2616](https://www.w3.org/Protocols/rfc2616/rfc2616-sec7.html)
public protocol EntityHeaderFields {
    var entityHeaderFields: [String: String] { get }
}

/// A type that represents an HTTP Entity described by
/// [RFC 2616](https://www.w3.org/Protocols/rfc2616/rfc2616-sec7.html)
public typealias EntityProtocol = EntityBody & EntityHeaderFields
