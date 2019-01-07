//
//  DetailViewController.swift
//  Who The Commit
//
//  Created by Alexis DELAHAYE on 07/01/2019.
//  Copyright © 2019 La Bonne Organisation. All rights reserved.
//

import UIKit

class DetailViewController: UITableViewController {

    @IBOutlet weak var detailDescriptionLabel: UILabel!
    @IBOutlet weak var tableView2: UITableView!
    

    func configureView() {
        // Update the user interface for the detail item.
        if let detail = detailItem {
            
            if let label = detailDescriptionLabel {
                label.text = detail.githubResult?.items[0].committer?.login
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
    
    

    


}

