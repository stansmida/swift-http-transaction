import Foundation

/**
 HTTPURLResponse extended to have a response body property.
 
 - Note: The intension is to propagate response body to corresponding
 `URLSessionTask` for a HTTP request. Since these data are strictly a part of
 a response that is a property of `URLSessionTask` it is not possible to use
 otherwise preferred ways of adding property to a type:
 + inheritance: Even if it is possible to subclass `HTTPURLResponse` and have
 `body` property there, it is not possible to transform received
 `HTTPURLResponse` instance to that subclass type.
 + composition: Since a completely new type would be introduced, it is not
 possible to assign it to `URLSessionTask`. One possibility is to use
 inheritance and composition together in a way where subclass of
 `HTTPURLResponse` is composed of `HTTPURLResponse` and `Data`. But this feels
 even worse than solution below - use a static property.
 
 - Note: Two additional conveniences are that response data are a natural part
 of response and `URLSessionTask` provides all data that takes part on HTTP
 transaction except response data. It has request, error and response properties
 but response data are missing here. `URLRequest` has `httpBody` property on the
 other side. Cons may be that response data are retained till response instance
 life and data object is copied in heap.
 */
public extension HTTPURLResponse {
    
    public struct BodySupport {
        fileprivate static let queue = DispatchQueue(label: "HTTPURLResponse.BodySupport.queue", qos: .userInteractive, attributes: .concurrent, autoreleaseFrequency: .never)
        fileprivate static let table = NSMapTable<HTTPURLResponse, NSData>(keyOptions: [.weakMemory], valueOptions: [.copyIn])
        public static var _debug = false
        public static func _debugPrint(_ context: String? = nil) {
            let count = BodySupport.table.count
            let content = BodySupport.table.keyEnumerator().allObjects.map({ (($0 as? HTTPURLResponse)?.url?.absoluteString ?? "Not an URL") })
            print("HTTPURLResponse.BodySupport>>> Items count: \(count); Context: \(String(describing: context)); Content:\n\(content.joined(separator: "\n"))")
        }
    }
    
    /// HTTP response message body data.
    public internal(set) var body: Data? {
        get {
            return BodySupport.queue.sync(execute: {
                if BodySupport._debug {
                    BodySupport._debugPrint("willGet")
                }
                return BodySupport.table.object(forKey: self) as Data?
            })
        }
        set {
            BodySupport.queue.async(flags: .barrier, execute: {
                BodySupport.table.setObject(newValue as NSData?, forKey: self)
                if BodySupport._debug {
                    BodySupport._debugPrint("didSet")
                }
            })
        }
    }
}
