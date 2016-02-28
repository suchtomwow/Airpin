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

  func fetchAllBookmarks(completion completion: BookmarkCompletion) throws {
    let endpoint = Endpoint(resourceTypes: [.Posts, .All])
    
    try fetchBookmarksWithEndpoint(endpoint, parameters: nil, completion: completion)
  }
  
  func fetchRecentBookmarks(completion: BookmarkCompletion) throws {
    let endpoint = Endpoint(resourceTypes: [.Posts, .Recent])
    try fetchBookmarksWithEndpoint(endpoint, completion: completion)
  }
  
  func fetchBookmarksWithEndpoint(endpoint: Endpoint, parameters: [NSURLQueryItem]? = nil, completion: BookmarkCompletion) throws {
    NetworkClient.sharedInstance.executeRequest(endpoint, parameters: parameters) { result in
      switch result {
      case .Success(let json):
        let posts = json
        
        let queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0)
        dispatch_async(queue) {
          for (_, subJson): (String, JSON) in posts {
            Bookmark.fromJSON(subJson).persist()
          }

          completion()
        }
        
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
        let updateTime = json["update_time"].stringValue
        let datetime = Formatter.JSON.dateFromString(updateTime)!        
        completion(datetime: datetime)
      case .Failure(let error):
        print(error.localizedDescription)
      }
    }
  }
  
  func markBookmarkAsRead(toRead: Bool, withURL URL: NSURL, andTitle title: String) {
    let endpoint = Endpoint(resourceTypes: [.Posts, .Add])
    let urlQI = NSURLQueryItem(name: "url", value: URL.absoluteString)
    let titleQI = NSURLQueryItem(name: "description", value: title)
    let toReadQI = NSURLQueryItem(name: "toread", value: toRead ? "yes" : "no")
    
    NetworkClient.sharedInstance.executeRequest(endpoint, parameters: [urlQI, titleQI, toReadQI], completion: nil)
  }
  
  }
}