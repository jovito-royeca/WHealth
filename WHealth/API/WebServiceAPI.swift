//
//  WebServiceAPI.swift
//  WHealth
//
//  Created by Jovito Royeca on 16.10.18.
//  Copyright © 2018 Jovito Royeca. All rights reserved.
//

import UIKit
import PromiseKit

enum EndPoints {
    static let Topics = "https://wexnermedical.osu.edu/blog/topics?blogId=F88D7CA3-2E58-4A8 0-AEFE-A0755FCD491D"
}

enum Error: Swift.Error {
    case badUrl
    case badResponse(Int)
}

class WebServiceAPI: NSObject {
    /*
     * Load topics from WebService
     */
    func fetchTopics() -> Promise<[[String: Any]]> {
        return Promise { seal  in
            guard let urlString = EndPoints.Topics.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                let url = URL(string: urlString) else {
                return
            }
            
            var rq = URLRequest(url: url)
            rq.httpMethod = "GET"

            firstly {
                URLSession.shared.dataTask(.promise, with: rq)
            }.compactMap {
                try JSONSerialization.jsonObject(with: $0.data) as? [[String: Any]]
            }.done { json in
                seal.fulfill(json)
            }.catch { error in
                seal.reject(error)
            }
        }
    }
    
    /*
     * Read the bundled JSON data.
     */
    func loadTopics() -> [[String: Any]]? {
        guard let path = Bundle.main.path(forResource: "topics",
                                          ofType: "json",
                                          inDirectory: "data"),
            FileManager.default.fileExists(atPath: path) else {
            return nil
        }
        
        let data = try! Data(contentsOf: URL(fileURLWithPath: path))
        
        guard let array = try! JSONSerialization.jsonObject(with: data,
                                                            options: .allowFragments) as? [[String: Any]] else {
            return nil
        }
        
        return array
    }
}
