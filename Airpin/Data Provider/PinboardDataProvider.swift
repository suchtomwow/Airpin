//
//  BookmarksDataProvider.swift
//  Airpin
//
//  Created by Thomas Carey on 4/17/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

struct PinboardDataProvider {
  private let networkOperations = PinboardNetworkOperations()
  
  func fetchAllBookmarks(completion: (bookmarks: [Bookmark]) -> Void?) {
    // 1: Call the https://api.pinboard.in/v1/posts/update endpoint to get the last updated time
    do {
      try networkOperations.getLastUpdate { datetime in
        print(datetime)
        
        do {
          try self.networkOperations.fetchAllBookmarks { bookmarks in
            return
          }
        } catch let error {
          print(error)
        }
      }
    } catch let error {
      print(error)
    }
    // 2: Compare against the stored last updated time
    
    // 3: If they differ, fetch all bookmarks from server
    
    // 4: If they are the same, fetch from Core Data
    
    // 5: If nothing is returned from Core Data, fetch from server
  }
}
