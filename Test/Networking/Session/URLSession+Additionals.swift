//
//  URLSession+Additionals.swift
//  TelephonyApp
//
//  Created by Sergey Kovalchyk on 16.09.2021.
//

import UIKit

enum HTTPMethod: String {
    case get    = "GET"
    case post   = "POST"
    case put    = "PUT"
    case delete = "DELETE"
    case head   = "HEAD"
    case patch  = "PATCH"
}

enum PListKey : String {
    case baseURLKey = "BaseURLPath"
    case apiVersionKey = "APIVersion"
}

enum ResponseType {
    case `default`
    case string
}

protocol Request {
    var url: URL { get }
    var method: HTTPMethod { get }
    var headers: [String: String]? { get }
    var parameters: [String: Any]? { get }
    var body: Data? { get }
    var responseType: ResponseType? { get }
}

extension Request {
    var body: Data? {
        return nil
    }
    
    var logDescription: String {
        let urlLog = "\nURL: \(url)"
        let bodyLog = "\nBODY: \(String(decoding: body ?? Data(), as: UTF8.self))"
        return "\n--> Request \(method.rawValue)" + urlLog + bodyLog
    }
    
    func typicalHeaders(withToken token: String? = "") -> [String: String] {
        let token = "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"
        return [
            "Accept": "application/vnd.github.v3+json",
            "Authorization": "token \(token)"
        ]
    }
    
    func makeURL(endpoint: String) -> URL {
        guard let baseURLPlist = Bundle.main.object(forInfoDictionaryKey: PListKey.baseURLKey.rawValue) as? String,
            !baseURLPlist.isEmpty else {
                assert(false, "Please add \(PListKey.baseURLKey.rawValue) value in PList for set BaseURL")
                return URL(string: "")!
        }
        
        guard let url = URL(string: baseURLPlist + endpoint) else {
            assert(false, "Wrong URL path")
            return URL(string: "")!
        }
        return url
    }
}

protocol URLSessionDataTaskMockable: AnyObject {
    func resume()
    func cancel()
}

typealias DataTaskResult<T> = (T?, URLResponse?, Error?) -> Void

protocol URLSessionMockable {
    func dataTask<T: Decodable>(with request: Request,
                                decoder: JSONDecoder?,
                                completion: @escaping DataTaskResult<T>) -> URLSessionDataTaskMockable
}

extension URLSession: URLSessionMockable {
    func dataTask<T: Decodable>(with request: Request,
                                decoder: JSONDecoder? = nil,
                                completion: @escaping DataTaskResult<T>) -> URLSessionDataTaskMockable {
        let urlRequest = prepareUrlRequest(from: request)
        return dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                do {
                    let coder = decoder ?? JSONDecoder()
                    let json = try coder.decode(T.self, from: data)
                    completion(json, response, error)
                } catch {
                    print(String(data: data, encoding: .utf8) ?? "", error)
                    completion(nil, response, error)
                }
            } else {
                completion(nil, response, error)
            }
        }
    }
    
    private func prepareUrlRequest(from request: Request) -> URLRequest {
        guard var urlComponents = URLComponents(url: request.url, resolvingAgainstBaseURL: true) else {
            fatalError("Couldn't create url components from url: \(request.url.absoluteString)")
        }
        
        var queryItems: [URLQueryItem] = []
        let convertedParams: [String: Any]? = request.parameters
        
        if request.method == .get {
            convertedParams?.forEach { arg in
                let (key, value) = arg
                queryItems.append(URLQueryItem(name: key.lowercased(), value: "\(value)"))
            }
            
            urlComponents.queryItems = queryItems
            urlComponents.percentEncodedQuery = urlComponents.percentEncodedQuery?.replacingOccurrences(of: "+", with: "%2B")
        }
        
        guard let url = urlComponents.url else {
            fatalError("Couldn't create url with these parameters")
        }
        
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = request.method.rawValue
        if !(request.headers?.contains(where: { $0.key == "Content-Type" }) ?? false) {
            urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        }
        
        if request.method != .get, let params = convertedParams {
            let httpBody = try? JSONSerialization.data(withJSONObject: params, options: [])
            urlRequest.httpBody = httpBody
        }
        
        if let body = request.body {
            urlRequest.httpBody = body
        }

        request.headers?.forEach { key, value in
            urlRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        return urlRequest
    }
    
    private func logDescription(_ response: URLResponse?,
                                _ data: Data) -> String {
        guard let httpResponse = response as? HTTPURLResponse else {
            return ""
        }
        let codeLog = "\nSTATUS: \(httpResponse.statusCode)"
        let urlLog = "\nURL: \(httpResponse.url?.absoluteString ?? "")"
        return "\n<-- Response" + codeLog + urlLog
    }
}

extension URLSessionDataTask: URLSessionDataTaskMockable { }

struct MyCodingKey: CodingKey {
    var stringValue: String
    
    var intValue: Int? {
        return nil
    }

    init?(stringValue: String) {
        self.stringValue = stringValue
    }

    init?(intValue: Int) {
        return nil
    }
}
