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

typealias BookmarkCompletion = (Results<Bookmark>) -> Void

class PinboardNetworkOperations {

    func fetchAllBookmarks(completion: @escaping () -> Void) {
        let endpoint = Endpoint(resourceTypes: [.posts, .all])
        fetch(with: Endpoint.DefaultBaseURL, endpoint: endpoint, parameters: nil, completion: completion)
    }

    func fetchPopularBookmarks(completion: (() -> Void)?) {
        let endpoint = Endpoint(resourceTypes: [.json, .popular])
        fetch(with: Endpoint.RSSBaseURL, endpoint: endpoint, completion: completion)
    }
    
    func fetch(with baseURL: String,
               endpoint: Endpoint,
               parameters: [URLQueryItem]? = nil,
               completion: (() -> Void)?) {
        NetworkClient.shared.executeRequest(with: baseURL, endpoint: endpoint, parameters: parameters) { result, username in
            switch result {
            case .success(let json):
                let posts = json

                DispatchQueue.realmQueue.async {
                    posts.forEach {
                        if baseURL == Endpoint.RSSBaseURL {
                            Bookmark.fromRSS(json: $1).persist(in: .inMemoryRealmConfiguration)
                        } else {
                            Bookmark.fromAPI(json: $1, username: username).persist(in: .defaultConfiguration)
                        }
                    }

                    completion?()
                }
                
            case .failure(let error):
                NSLog(error.localizedDescription)
            }
        }
    }
    
    func getLastUpdated(completion: @escaping (_ datetime: Date) -> Void) {
        let endpoint = Endpoint(resourceTypes: [.posts, .update])
        NetworkClient.shared.executeRequest(with: Endpoint.DefaultBaseURL, endpoint: endpoint) { result, _ in
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
    
    func toggleReadState(toRead: Bool, for bookmark: Bookmark, completion: ((Result<Bool>, _ username: String?) -> ())?) {
        let combinedTags = bookmark.tags.reduce("") { result, tag in
            result + "+" + tag.name
        }
        addBookmark(with: bookmark.url, title: bookmark.title, extended: bookmark.extended, isPrivate: !bookmark.shared, toRead: toRead, tags: combinedTags, completion: completion)
    }
    
    func delete(with URL: Foundation.URL) {
        let endpoint = Endpoint(resourceTypes: [.posts, .delete])
        let urlQI = URLQueryItem(name: "url", value: URL.absoluteString)
        
        NetworkClient.shared.executeRequest(with: Endpoint.DefaultBaseURL, endpoint: endpoint, parameters: [urlQI], completion: nil)
    }
    
    func addBookmark(with url: URL, title: String, extended: String?, isPrivate: Bool, toRead: Bool, tags: String, completion: ((Result<Bool>, _ username: String?) -> ())?) {
        let endpoint = Endpoint(resourceTypes: [.posts, .add])
        let urlQI = URLQueryItem(name: "url", value: url.absoluteString)
        let titleQI = URLQueryItem(name: "description", value: title)
        let descriptionQI = URLQueryItem(name: "extended", value: extended)
        let toReadQI = URLQueryItem(name: "toread", value: toRead ? "yes" : "no")
        let privacyQI = URLQueryItem(name: "shared", value: isPrivate ? "no" : "yes")
        let tagsQI = URLQueryItem(name: "tags", value: tags)

        NetworkClient.shared.executeRequest(with: Endpoint.DefaultBaseURL, endpoint: endpoint, parameters: [urlQI, titleQI, descriptionQI, toReadQI, privacyQI, tagsQI]) { result, username in
            switch result {
            case .success:
                completion?(Result.success(true), username)
            case .failure(let error):
                completion?(Result.failure(error), nil)
            }
        }
    }
}
