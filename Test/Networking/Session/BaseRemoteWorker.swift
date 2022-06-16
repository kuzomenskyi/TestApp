//
//  BaseRemoteWorker.swift
//  TelephonyApp
//
//  Created by Sergey Kovalchyk on 16.09.2021.
//

import Foundation
import UIKit

class BaseRemoteWorker {
    private let manager: APIManager
    
    init(manager: APIManager = APIManager()) {
        self.manager = manager
    }
}

extension BaseRemoteWorker {
    // MARK: All apps networking methods
    // Method to call server and return callback with parsed generic model or error (All apps)
    @discardableResult
    func callModel<M: Decodable>(_ request: Request,
                                 decoder: JSONDecoder? = nil,
                                 _ completion: @escaping Completions.ModelResult<M>) -> URLSessionDataTaskMockable? {

        return manager.sessionRequest(with: request, decoder: decoder) { (model: M?, error) in
            completion(model, error)
        }
    }
    
    // Method to call server and return callback with array of generic models or error (All apps)
    @discardableResult
    func callArrayOfModels<M: Decodable>(_ request: Request,
                                         _ completion: @escaping Completions.ArrayResult<M>) -> URLSessionDataTaskMockable? {
        return manager.sessionRequest(with: request) { (models: [M]?, error) in
            completion(models, error)
        }
    }
}
