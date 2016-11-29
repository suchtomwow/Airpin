//
//  BookmarkNetworkOperations.swift
//  Airpin
//
//  Created by Thomas Carey on 7/21/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

typealias BookmarkCompletion = () -> Void

class PinboardNetworkOperations {
    
    func fetchAllBookmarks(completion: @escaping BookmarkCompletion) throws {
        let endpoint = Endpoint(resourceTypes: [.posts, .all])
        
        try fetch(with: endpoint, parameters: nil, completion: completion)
    }
    
    func fetchRecentBookmarks(completion: @escaping BookmarkCompletion) throws {
        let endpoint = Endpoint(resourceTypes: [.posts, .recent])
        try fetch(with: endpoint, completion: completion)
    }
    
    func fetch(with endpoint: Endpoint, parameters: [URLQueryItem]? = nil, completion: @escaping BookmarkCompletion) throws {
        NetworkClient.shared.executeRequest(with: endpoint, parameters: parameters) { result in
            switch result {
            case .success(let json):
                let posts = json
                
                DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async {
                    for (_, subJson): (String, JSON) in posts {
                        Bookmark.from(json: subJson).persist()
                    }
                    
                    completion()
                }
                
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func getLastUpdated(completion: @escaping (_ datetime: Date) -> Void) throws {
        let endpoint = Endpoint(resourceTypes: [.posts, .update])
        NetworkClient.shared.executeRequest(with: endpoint) { result in
            switch result {
            case .success(let json):
                let updateTime = json["update_time"].stringValue
                let datetime = Formatter.JSON.date(from: updateTime)!
                completion(datetime)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    func toggleReadState(toRead: Bool, withURL URL: Foundation.URL, andTitle title: String) {
        let endpoint = Endpoint(resourceTypes: [.posts, .add])
        let urlQI = URLQueryItem(name: "url", value: URL.absoluteString)
        let titleQI = URLQueryItem(name: "description", value: title)
        let toReadQI = URLQueryItem(name: "toread", value: toRead ? "yes" : "no")
        
        NetworkClient.shared.executeRequest(with: endpoint, parameters: [urlQI, titleQI, toReadQI], completion: nil)
    }
    
    func delete(with URL: Foundation.URL) {
        let endpoint = Endpoint(resourceTypes: [.posts, .delete])
        let urlQI = URLQueryItem(name: "url", value: URL.absoluteString)
        
        NetworkClient.shared.executeRequest(with: endpoint, parameters: [urlQI], completion: nil)
    }
}
