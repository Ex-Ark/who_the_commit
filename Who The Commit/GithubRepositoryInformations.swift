//
//  GithubCommitInformations.swift
//  Who The Commit
//
//  Created by Alexis DELAHAYE on 14/01/2019.
//  Copyright © 2019 La Bonne Organisation. All rights reserved.
//

import Foundation

class GithubRepositoryInformations : Decodable {
    var stars: Int
    var forks: Int
    var watchers: Int
    
    enum CodingKeys: String, CodingKey {
        case stars = "stargazers_count"
        case forks = "forks_count"
        case watchers = "watchers_count"
    }
    
}
