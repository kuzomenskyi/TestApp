//
//  AuthRouter.swift
//  TelephonyApp
//
//  Created by Sergey Kovalchyk on 29.09.2021.
//

import Foundation

enum AuthRouter: Request {
    case getUserInfo
    case getUserReposByName(userName: String)
    case getUserReposByURL(userReposPath: String)
    
    var url: URL? {
        switch self {
        case .getUserInfo:
            guard let url = URL(string: "https://api.github.com/user") else {
                return nil
            }
            return url
        case .getUserReposByName(let userName):
            guard let url = URL(string: "https://api.github.com/users/\(userName)/repos") else {
                fatalError("Wrong url")
            }
            return url
        case .getUserReposByURL(userReposPath: let userReposPath):
            guard let url = URL(string: userReposPath) else {
                fatalError("Wrong url")
            }
            return url
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getUserInfo, .getUserReposByName, .getUserReposByURL: return .get
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .getUserInfo, .getUserReposByName, .getUserReposByURL:  return typicalHeaders()
        }
    }
    
    var parameters: [String: Any]? {
        switch self {
        case .getUserInfo, .getUserReposByName, .getUserReposByURL: return nil
        }
    }
    
    var responseType: ResponseType? {
        switch self {
        case .getUserInfo, .getUserReposByName, .getUserReposByURL: return nil
        }
    }
}
