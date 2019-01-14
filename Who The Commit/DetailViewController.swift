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
    @IBOutlet weak var spinCount: UIActivityIndicatorView!
    @IBOutlet weak var countLabel: UILabel!
}

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    @IBOutlet weak var tableView2: UITableView!
    
    var ghclient: GithubClient = GithubClient()
    
    var objects = [GithubCommit]()
    
    var commitDetailController: CommitDetailController? = nil

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            self.title = detail.message
            
            if (detail.githubResult == nil) {
                self.ghclient.search(commit: detail, handler: {
                    (results) in
                    detail.githubResult = results
                    // filter only interesting ones
                    self.objects = results.items.filter({ (GithubCommit) -> Bool in
                        GithubCommit.score!  >= 30.00
                    })
                    self.tableView2.reloadData()
                    self.loadAdditionnalInfos()
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showCommitDetail" {
            if let indexPath = tableView2.indexPathForSelectedRow {
                let object = objects[indexPath.row]
                let controller = segue.destination as! CommitDetailController
                controller.commit = object
            }
        }
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
    
    // TODO: check if search_quota (10 per minute) is exceeded by getting N url
    // DONE: yes it does
    /*
 {
    "message": "API rate limit exceeded for XXX.XXX.XX.XX (But here's the good news: Authenticated requests get a higher rate limit. Check out the documentation for more details.)",
    "documentation_url": "https://developer.github.com/v3/#rate-limiting"
}
 */
    // we only do it for the first ones then
    // proof it works
    func loadAdditionnalInfos(){
        for (index, commit) in objects.prefix(3).enumerated() {
            request(urlString: commit.repository?.apiUrl ?? "", completionHandler: { data in
                guard let data = data else {
                    print(String(format: "Error while getting the repository: %@",commit.repository?.apiUrl ?? "nil"))
                    return
                }
                guard let repoInfos = try? JSONDecoder().decode(GithubRepositoryInformations.self, from: data) else {
                    print("Error: Couldn't decode full information about repository")
                    return
                }
                print(repoInfos)
                self.objects[index].full_infos = repoInfos
                let indexPath = IndexPath(item: index, section: 0)
                self.tableView2.reloadRows(at: [indexPath], with: .top)
            })
        }
         self.tableView2.reloadData()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commitCell", for: indexPath) as! CommitCell
        
        let object = objects[indexPath.row]
        cell.committerNameLabel.text = object.committer?.login
        cell.repoNameLabel.text = object.repository?.fullName
        cell.spin.startAnimating()
        cell.committerAvatarImage.image = nil
        
        // hide additional infos for now
        if object.full_infos == nil {
            cell.spinCount.startAnimating()
            cell.countLabel.isHidden = true
        }
        else{
            cell.spinCount.stopAnimating()
            cell.countLabel.text = String(format: "%d stars", object.full_infos!.stars)
            cell.countLabel.isHidden = false
        }
        
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
