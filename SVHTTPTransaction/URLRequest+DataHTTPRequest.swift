import Foundation
import SVFoundation

extension URLSession {
    
    public func dataTask<T: DataHTTPRequest>(with request: T, asyncReturn: @escaping AsyncReturn<SpecificFailable<T.ResponseBody, HTTPTransactionError<T.ProblemDetail>>>) throws -> URLSessionDataTask {
        return dataTask(withHTTPURLRequest: try request.urlRequest(), asyncReturn: { response in
            asyncReturn(self.process(response: response, of: T.self))
        })
    }
    
    /// Transforms `HTTPURLResponse` into `DataHTTPRequest.Response` or fails
    /// with `HTTPTransactionError`.
    private func process<T: DataHTTPRequest>(response: Failable<HTTPURLResponse>, of _: T.Type) -> SpecificFailable<T.ResponseBody, HTTPTransactionError<T.ProblemDetail>> {
        do {
            let httpURLResponse = try response.unwrap()
            let data = httpURLResponse.body!
            guard httpURLResponse.statusCode == T.expectedStatusCode else {
                return .failure(.badResponse(httpURLResponse, try? T.ProblemDetail(data: data)))
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
