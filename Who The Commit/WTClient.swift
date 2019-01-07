//
//  WTClient.swift
//  Who The Commit
//
//  Created by Alexis DELAHAYE on 07/01/2019.
//  Copyright © 2019 La Bonne Organisation. All rights reserved.
//

import Foundation

class WTClient {
    func getUrl() -> String {
        return "https://whatthecommit.com/index.json"
    }
    
    func getWTCommit(handler: @escaping (WTCommit) -> ()){
        let session = URLSession.shared
        let urlString = getUrl()
        if let url = URL(string: urlString) {
            let task = session.dataTask(with: url) { (data, _, _) in
                if let data = data {
                    //let string = String(data: data, encoding: String.Encoding.utf8)
                    guard let commit = try? JSONDecoder().decode(WTCommit.self, from: data) else {
                        print("Error: Couldn't decode data into WTCommit")
                        return
                    }
                    handler(commit)
                }
            }
            task.resume()
        }
    }
    
}
