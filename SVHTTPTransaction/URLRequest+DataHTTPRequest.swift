import Foundation
import SVFoundation

extension URLSession {
    
    /**
     Creates a task that retrieves the contents of the specified URL,
     then calls a handler upon completion.

     After you create the task, you must start it by calling its resume() method.

     - Note: If `DataHTTPRequest.urlRequest()` will throw, a task will still
     be created. Such task has URL ["about:invalid"](https://www.iana.org/assignments/about-uri-tokens/about-uri-tokens.xhtml). Completion of the task results in
     `HTTPTransactionError.badRequest` with thrown error failure.

     Other alternatives how to deal with failure of `URLRequest` representation
     of `DataHTTPRequest` were:
       - Propagating error `dataTask<T: DataHTTPRequest>(with request: T, asyncReturn: @escaping AsyncReturn<SpecificFailable<T.ResponseBody, HTTPTransactionError<T.ProblemDetail>>>) throws -> URLSessionDataTask`.
       - Instant async return with thrown error and method with optional return
         type `dataTask<T: DataHTTPRequest>(with request: T, asyncReturn: @escaping AsyncReturn<SpecificFailable<T.ResponseBody, HTTPTransactionError<T.ProblemDetail>>>) -> URLSessionDataTask?`
       - Support `about` scheme alongside with `http` and `https` to give
         implementor a chance to deal with failure during `URLRequest` representation.

     Chosen solution is based on meeting criteria:
       - Method signature as close as possible to standard ones. Always returns
         `URLSessionDataTask`, not throwing.
       - Preserve chance to fail with throwing error for
         `DataHTTPRequest.urlRequest()`.
       - Handle "about:invalid", if needed, internally.

     - Parameters:
       - request: A request.
       - asyncReturn: A processed response to resolve.
     - Returns: The new session data task.
     */
    public func dataTask<T: DataHTTPRequest>(with request: T, asyncReturn: @escaping AsyncReturn<SpecificFailable<T.ResponseBody, HTTPTransactionError<T.ProblemDetail>>>) -> URLSessionDataTask {
        do {
            return dataTask(withHTTPURLRequest: try request.urlRequest(), asyncReturn: { result in
                asyncReturn(self.process(result: result, of: T.self))
            })
        } catch {
            return dataTask(with: URL(string: "about:invalid")!, completionHandler: { _, _, _  in
                asyncReturn(.failure(.badRequest(error)))
            })
        }
    }

    private func process<T: DataHTTPRequest>(result: Failable<HTTPURLResponse>, of _: T.Type) -> SpecificFailable<T.ResponseBody, HTTPTransactionError<T.ProblemDetail>> {
        do {
            let httpURLResponse = try result.unwrap()
            let data = httpURLResponse.body!
            guard (200..<300).contains(httpURLResponse.statusCode) else {
                return .failure(.notSuccess(httpURLResponse, try? T.ProblemDetail(data: data)))
            }
            do {
                return .ok(try T.ResponseBody(data: data))
            } catch {
                return .failure(.decodingFailure(error))
            }
        } catch {
            return .failure(.noResponse(error))
        }
    }
}
