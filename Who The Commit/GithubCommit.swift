//
//  GithubCommit.swift
//  Who The Commit
//
//  Created by Alexis DELAHAYE on 07/01/2019.
//  Copyright © 2019 La Bonne Organisation. All rights reserved.
//

import Foundation

class GithubCommit: Decodable {
    var apiUrl: String
    var htmlUrl: String
    var commit: Commit
    var committer: Committer?
    var repository: Repository?
    
    enum CodingKeys: String, CodingKey {
        case htmlUrl = "html_url"
        case apiUrl = "url"
        
        case commit
        case committer
        case repository
    }
    
    class Commit: Decodable {
        var message: String?
        var tree: Tree
        var date: Date? {
            return ISO8601DateFormatter().date(from: author.date)
        }
        var author: Author
        var hash : String? {
            return tree.sha
        }
        class Tree: Decodable {
            var sha: String?
        }
        class Author: Decodable {
            var date: String
        }
    }
    
    class Committer: Decodable {
        var login: String?
        var avatar: String?
        var htmlUrl: String?
        var apiUrl: String?
        
        enum CodingKeys: String, CodingKey {
            case avatar = "avatar_url"
            case htmlUrl = "html_url"
            case apiUrl = "url"
            case login
        }
    }
    
    class Repository: Decodable {
        var name: String?
        var description: String?
        var apiUrl: String?
        var htmlUrl: String?
        
        enum CodingKeys: String, CodingKey {
            case name
            case description
            case htmlUrl = "html_url"
            case apiUrl = "url"
        }
    }
}

