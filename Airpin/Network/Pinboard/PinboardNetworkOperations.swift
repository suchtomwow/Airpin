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
    
    func toggleReadState(toRead: Bool, for bookmark: Bookmark, completion: ((Result<Bool>) -> ())?) {
        addBookmark(with: bookmark.url, title: bookmark.title, description: bookmark.description, isPrivate: !bookmark.shared, toRead: toRead, tags: bookmark.userTags, completion: completion)
    }
    
    func delete(with URL: Foundation.URL) {
        let endpoint = Endpoint(resourceTypes: [.posts, .delete])
        let urlQI = URLQueryItem(name: "url", value: URL.absoluteString)
        
        NetworkClient.shared.executeRequest(with: endpoint, parameters: [urlQI], completion: nil)
    }
    
    func addBookmark(with url: URL, title: String, description: String?, isPrivate: Bool, toRead: Bool, tags: String, completion: ((Result<Bool>) -> ())?) {
        let endpoint = Endpoint(resourceTypes: [.posts, .add])
        let urlQI = URLQueryItem(name: "url", value: url.absoluteString)
        let titleQI = URLQueryItem(name: "description", value: title)
        let descriptionQI = URLQueryItem(name: "extended", value: description)
        let toReadQI = URLQueryItem(name: "toread", value: toRead ? "yes" : "no")
        let privacyQI = URLQueryItem(name: "shared", value: isPrivate ? "no" : "yes")
        let tagsQI = URLQueryItem(name: "tags", value: tags)

        NetworkClient.shared.executeRequest(with: endpoint, parameters: [urlQI, titleQI, descriptionQI, toReadQI, privacyQI, tagsQI]) { result in
            switch result {
            case .success:
                completion?(Result.success(true))
            case .failure(let error):
                completion?(Result.failure(error))
            }
        }
    }
}
