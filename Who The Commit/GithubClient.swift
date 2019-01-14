//
//  GithubClient.swift
//  Who The Commit
//
//  Created by Alexis DELAHAYE on 07/01/2019.
//  Copyright © 2019 La Bonne Organisation. All rights reserved.
//

import Foundation

class GithubClient {
    
    func search(commit: WTCommit, handler: @escaping (GithubSearchResult) -> ()) {
        return getGithubResult(commit: commit.message, handler: handler)
    }
    
    func getUrl(q: String) -> String {
        return "https://api.github.com/search/commits?q=\(q.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!)"
    }
    
    func getGithubResult(commit: String, handler: @escaping (GithubSearchResult) -> ()){
        let session = URLSession.shared
        let urlString = getUrl(q: commit)
        if let url = URL(string: urlString) {
            var request = URLRequest(url: url)
            request.setValue("application/vnd.github.cloak-preview", forHTTPHeaderField: "Accept")
            
            let task = session.dataTask(with: request) { (data, _, _) in
                if let data = data {
                    //let string = String(data: data, encoding: String.Encoding.utf8)
                    guard let commit = try? JSONDecoder().decode(GithubSearchResult.self, from: data) else {
                        print("Error: Couldn't decode data into GithubSearchResult")
                        return
                    }
                    DispatchQueue.main.async {
                        handler(commit)
                    }
                } else {
                    print("ERROROOOOOROR")
                }
            }
            
            task.resume()
        }
    }
    
    
}
