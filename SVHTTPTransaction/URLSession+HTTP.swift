import Foundation
import SVFoundation

public extension URLSession {
    
    /**
     Stronger response type. It asynchronously returns either response or error.
     
     - Requires: Request URL scheme to be either HTTPS or HTTP.
     - Postcondition: `HTTPURLResponse.body` in `asyncReturn` is guaranteed
     to be not nil.
     */
    public func dataTask(withHTTPURLRequest request: URLRequest, asyncReturn: @escaping AsyncReturn<Failable<HTTPURLResponse>>) -> URLSessionDataTask {
        precondition(["http", "https"].contains(request.url?.scheme), "Only HTTP protocol is allowed here.")
        return dataTask(with: request, completionHandler: { data, urlResponse, error in
            do {
                guard error == nil else {
                    throw error!
                }
                /* - Note: From the docs: "If the request completes
                 successfully, the data parameter of the completion handler
                 block contains the resource data, and the error parameter is
                 nil. If the request fails, the data parameter is nil and the
                 error parameter contain information about the failure. If a
                 response from the server is received, regardless of whether the
                 request completes successfully or fails, the response parameter
                 contains that information." - Therefore for HTTP there are
                 either data (may be empty but not nil) and HTTPURLResponse in
                 case of success or error in case of failure.*/
                guard data != nil, let httpURLResponse = urlResponse as? HTTPURLResponse else {
                    assertionFailure()
                    throw UnexpectedError(errorDescription: "Unexpected arguments. Request: \(request). Data: \(String(describing: data)); Response: \(String(describing: urlResponse)); Error: \(String(describing: error))")
                }
                httpURLResponse.body = data
                asyncReturn(.ok(httpURLResponse))
            } catch {
                asyncReturn(.failure(error))
            }
        })
    }
}
