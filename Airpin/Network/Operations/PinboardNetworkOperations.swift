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

  func fetchAllBookmarks(completion: BookmarkCompletion) throws {
    let endpoint = Endpoint(resourceTypes: [.Posts, .All])
    
    try fetchBookmarksWithEndpoint(endpoint, parameters: nil, completion: completion)
  }
  
  func fetchRecentBookmarks(completion: BookmarkCompletion) throws {
    let endpoint = Endpoint(resourceTypes: [.Posts, .Recent])
    try fetchBookmarksWithEndpoint(endpoint, completion: completion)
  }
  
  func fetch(with endpoint: Endpoint, parameters: [URLQueryItem]? = nil, completion: BookmarkCompletion) throws {
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
  
  func getLastUpdated(completion: (datetime: Date) -> Void) throws {
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
  
  func toggleReadState(toRead: Bool, withURL URL: Foundation.URL, andTitle title: String) {
    let endpoint = Endpoint(resourceTypes: [.Posts, .Add])
    let urlQI = URLQueryItem(name: "url", value: URL.absoluteString)
    let titleQI = URLQueryItem(name: "description", value: title)
    let toReadQI = URLQueryItem(name: "toread", value: toRead ? "yes" : "no")
    
    NetworkClient.sharedInstance.executeRequest(endpoint, parameters: [urlQI, titleQI, toReadQI], completion: nil)
  }
  
  func delete(with URL: Foundation.URL) {
    let endpoint = Endpoint(resourceTypes: [.Posts, .Delete])
    let urlQI = URLQueryItem(name: "url", value: URL.absoluteString)
    
    NetworkClient.sharedInstance.executeRequest(endpoint, parameters: [urlQI], completion: nil)
  }
}
