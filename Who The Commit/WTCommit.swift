//
//  WTCommit.swift
//  Who The Commit
//
//  Created by Alexis DELAHAYE on 07/01/2019.
//  Copyright © 2019 La Bonne Organisation. All rights reserved.
//

import Foundation

class WTCommit: Decodable {
    
    var hash: String
    var message: String
    var permalink: String
    var githubResult: GithubSearchResult?
    
    init(hash: String, message: String, permalink: String) {
        self.hash = hash
        self.message = message
        self.permalink = permalink
    }
    
    enum CodingKeys: String, CodingKey {
        case hash
        case message = "commit_message"
        case permalink
    }
}
