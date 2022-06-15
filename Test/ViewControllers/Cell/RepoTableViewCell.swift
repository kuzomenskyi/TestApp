//
//  RepoTableViewCell.swift
//  Test
//
//  Created by Sergey on 15.06.2022.
//

import UIKit

class RepoTableViewCell: UITableViewCell, CellInterface {

    @IBOutlet private weak var repoNameLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure(repo: Repo) {
        self.repoNameLabel.text = repo.name
    }
}
