//
//  ViewController.swift
//  Test
//
//  Created by Sergey on 30.05.2022.
//

import UIKit

class ViewController: UIViewController, IAlertHelper {

    @IBOutlet private var profileIV: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        profileIV.backgroundColor = .darkGray
    }

    @IBAction func getUserDataPressed(_ sender: UIButton) {
        getData()
    }
    
    private func getData() {
        GithubWorker.shared.getUserData { [weak self] user, error in
            print("User: \(user)")
            print("Error: \(error)")
            guard let self = self else { return }
            guard error == nil else {
                self.presentErrorAlert(error!)
                return
            }
            
            if let user = user {
                self.showRepositories(user: user)
                
                guard let avatarURLString = user.avatarURL else { return }
                guard let avatarURL = URL(string: avatarURLString) else { return }
                DispatchQueue.main.async {
                    do {
                        let data = try Data(contentsOf: avatarURL)
                        guard let image = UIImage(data: data) else {
                            self.presentErrorAlert(CustomError("Image is nil"))
                            return
                        }
                        self.profileIV.image = image
                    } catch {
                        self.presentErrorAlert(error)
                    }
                }
            }
        }
    }
    
    private func showRepositories(user: User) {
//        self.performSegue(withIdentifier: "showUserRepos", sender: user)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showUserRepos",
           let vc = segue.destination as? RepositoriesViewController {
            vc.user = sender as? User
        }
    }
}

