//
//  APIManager.swift
//  TelephonyApp
//
//  Created by Sergey Kovalchyk on 16.09.2021.
//

import UIKit


final class APIManager {
    
    private let session: URLSessionMockable
    
    init(session: URLSessionMockable = URLSession.shared) {
        self.session = session
    }
    
    @discardableResult
    func sessionRequest<T: Decodable>(with request: Request,
                                      decoder: JSONDecoder? = nil,
                                      completion: @escaping Completions.ModelResult<T>) -> URLSessionDataTaskMockable? {
        let dataTask = session.dataTask(with: request, decoder: decoder) { (data: ResponseData<T>?, response, error) in
            DispatchQueue.main.async {
                if data?.error != nil {
                    // Handle backend error
                    let backendError = self.error(errorValue: data?.error, response: response)
                    completion(nil, backendError)
                } else if error != nil {
                    // Complete with network error
                    if let urlError = error as? URLError, urlError.code == .cancelled {
                        completion(nil, urlError)
                    } else {
                        completion(nil, error)
                    }
                } else {
                    // Complete with successfully parsed model
                    completion(data?.data, nil)
                }
            }
        }
        
        guard let dataTask = dataTask else {
            completion(nil, CustomError("Data task is nil"))
            return nil
        }
        
        dataTask.resume()
        return dataTask
    }
}

private extension APIManager {
    // MARK: Private methods
    func error(errorValue: ErrorValue?, response: URLResponse?) -> Error? {
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
        switch errorValue {
        case .generic(let error):
            return self.error(
                code: Int(error.code?.digits ?? "") ?? statusCode,
                description: error.message,
                infoDic: [NSLocalizedDescriptionKey: error.message, "genericError": error]
            )

        case .none:
            return nil
        }
    }
    
    func error(code: Int, description: String, infoDic: [String: Any]) -> Error {
        return NSError(domain: "generalErrors", code: code, userInfo: infoDic) as Error
    }
}
