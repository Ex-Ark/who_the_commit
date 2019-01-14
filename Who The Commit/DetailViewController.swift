//
//  DetailViewController.swift
//  Who The Commit
//
//  Created by Alexis DELAHAYE on 07/01/2019.
//  Copyright © 2019 La Bonne Organisation. All rights reserved.
//

import UIKit

class CommitCell: UITableViewCell {
    @IBOutlet weak var committerNameLabel: UILabel!
    
    @IBOutlet weak var committerAvatarImage: UIImageView!
    @IBOutlet weak var repoNameLabel: UILabel!
    @IBOutlet weak var spin: UIActivityIndicatorView!
}

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView2: UITableView!
    
    var ghclient: GithubClient = GithubClient()
    
    var objects = [GithubCommit]()

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            self.title = detail.message
            
            if (detail.githubResult == nil) {
                self.ghclient.search(commit: detail, handler: {
                    (results) in
                    detail.githubResult = results
                    self.objects = results.items
                    self.tableView2.reloadData()
                })
            } else {
                self.objects = detail.githubResult!.items
                //self.tableView2.reloadData()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView2.delegate = self
        tableView2.dataSource = self
        // Do any additional setup after loading the view, typically from a nib.
        configureView()
    }

    var detailItem: WTCommit? {
        didSet {
            // Update the view.
            configureView()
        }
    }
    
    // MARK: - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return objects.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commitCell", for: indexPath) as! CommitCell
        
        let object = objects[indexPath.row]
        cell.committerNameLabel.text = object.committer?.login
        cell.repoNameLabel.text = object.repository?.name
        cell.spin.startAnimating()
        cell.committerAvatarImage.image = nil
        request(urlString: object.committer?.avatar ?? "", completionHandler: { data in
            guard let data = data else {
                // Display error
                return
            }
            cell.spin.stopAnimating()
    
            // UI thread, use data image
            cell.committerAvatarImage.image = UIImage(data: data)
        })
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return false
    }
}
