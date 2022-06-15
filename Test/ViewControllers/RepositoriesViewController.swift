//
//  RepositoriesViewController.swift
//  Test
//
//  Created by Sergey on 15.06.2022.
//

import UIKit

final class RepositoriesViewController: UIViewController {

    @IBOutlet private weak var tableView: UITableView!
    
    var user: User?
    private var source = [Repo]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(RepoTableViewCell.cellNib, forCellReuseIdentifier: RepoTableViewCell.id)
        getUserRepositories()
    }
    
    
    private func getUserRepositories() {
        guard let path = user?.reposURL else {
            fatalError("no repo url")
        }
        GithubWorker.shared.getUserRepos(path: path) { [weak self] result, error in
            guard let self = self else { return }
            if let error = error {
                fatalError(error.localizedDescription)
            } else if let result = result {
                self.updateTableView(repos: result)
            }
        }
    }
    
    private func updateTableView(repos: [Repo]) {
        source = repos
        tableView.reloadData()
    }
}

extension RepositoriesViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return source.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: RepoTableViewCell.id) as? RepoTableViewCell else { return UITableViewCell() }
        cell.configure(repo: source[indexPath.row])
        return cell
    }
}
