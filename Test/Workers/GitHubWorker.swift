//
//  GitHubWorker.swift
//  Test
//
//  Created by Sergey on 15.06.2022.
//

import Foundation

final class GithubWorker: BaseRemoteWorker  {
    static var shared: GithubWorker {
        return GithubWorker()
    }
    
    func getUserData(_ result: @escaping Completions.ModelResult<User>) {
        let request = AuthRouter.getUserInfo
        callModel(request, result)
    }
    
    func getUserRepos(path: String,
                      _ result: @escaping Completions.ArrayResult<Repo>) {
        let request = AuthRouter.getUserReposByURL(userReposPath: path)
        callArrayOfModels(request, result)
    }
}
