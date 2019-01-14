//
//  CommitDetailController.swift
//  Who The Commit
//
//  Created by Alexis DELAHAYE on 14/01/2019.
//  Copyright © 2019 La Bonne Organisation. All rights reserved.
//

import UIKit

class CommitDetailController: UIViewController {
        
    @IBOutlet weak var commitMessageLabel: UILabel!
    
    @IBOutlet weak var commitHashLabel: UILabel!
    
    @IBOutlet weak var httpCommitLink: UIButton!
    @IBAction func pressCommitUrl(_ sender: Any) {
        UIApplication.shared.openURL(NSURL(string: (commit?.htmlUrl)!)! as URL)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail = commit {
            self.title = detail.committer?.login
            self.commitMessageLabel.text = detail.commit.message
            self.commitHashLabel.text = detail.commit.hash
            self.httpCommitLink.setTitle("Open commit in Github", for: .normal)
        }
    }
    
    var commit: GithubCommit? {
        didSet {
            if (isViewLoaded) {
            configureView()
            }
        }
    }
    
}
