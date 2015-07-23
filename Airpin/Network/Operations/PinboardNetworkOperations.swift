//
//  BookmarkNetworkOperations.swift
//  Airpin
//
//  Created by Thomas Carey on 7/21/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import Foundation

typealias BookmarkCompletion = (bookmarks: [Bookmark]) -> Void

struct PinboardNetworkOperations {
  func fetchAllBookmarks(completion: BookmarkCompletion) throws {
    let endpoint = Endpoint(resourceTypes: [.Posts, .All])
    try fetchBookmarksWithEndpoint(endpoint, completion: completion)
  }
  
  func fetchRecentBookmarks(completion: BookmarkCompletion) throws {
    let endpoint = Endpoint(resourceTypes: [.Posts, .All])
    try fetchBookmarksWithEndpoint(endpoint, completion: completion)
  }
  
  func fetchBookmarksWithEndpoint(endpoint: Endpoint, completion: BookmarkCompletion) throws {
    NetworkClient.sharedInstance.executeRequest(endpoint) { (result: Result<JSON>) in
      switch result {
      case .Success(let json):
          var bookmarks: [Bookmark] = []
          let posts = json["posts"] as! [JSON]
          posts.map { bookmarks.append(Bookmark(json: $0)) }
        
        // Save bookmarks to disk
      case .Failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  func getLastUpdated(completion: (datetime: NSDate) -> Void) throws {
    let endpoint = Endpoint(resourceTypes: [.Posts, .Update])
    NetworkClient.sharedInstance.executeRequest(endpoint) { (result: Result<JSON>) in
      switch result {
      case .Success(let json):
        let updateTime = json["update_time"] as! String
        completion(datetime: Formatter.JSON.dateFromString(updateTime)!)
      case .Failure(let error):
        print(error.localizedDescription)
      }
    }
  }
}