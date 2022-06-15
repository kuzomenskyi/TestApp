//
//  ViewController.swift
//  Test
//
//  Created by Sergey on 30.05.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func getUserDataPressed(_ sender: UIButton) {
        getData()
    }
    
    private func getData() {
        GithubWorker.shared.getUserData { [weak self] user, error in
            guard let self = self else { return }
            if let user = user {
                self.showRepositories(user: user)
            }
        }
    }
    
    private func showRepositories(user: User) {
        self.performSegue(withIdentifier: "showUserRepos", sender: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserRepos",
           let vc = segue.destination as? RepositoriesViewController {
            vc.user = sender as? User
        }
    }
}

