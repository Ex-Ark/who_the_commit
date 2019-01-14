//
//  HttpUtils.swift
//  Who The Commit
//
//  Created by Alexis DELAHAYE on 14/01/2019.
//  Copyright © 2019 La Bonne Organisation. All rights reserved.
//

import Foundation

func request(urlString: String, completionHandler: @escaping (Data?) ->
    Void) {
    guard let url = URL(string: urlString) else {
        completionHandler(nil)
        return
    }
    // Background thread
    DispatchQueue.global().async {
        let data = try? Data(contentsOf: url)
        // Main/UI thread
        DispatchQueue.main.async {
            completionHandler(data)
        }
    }
}
