//
//  BookmarksDataProvider.swift
//  Airpin
//
//  Created by Thomas Carey on 4/17/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

struct PinboardDataProvider {
  private let networkOperations = PinboardNetworkOperations()
  private let diskOperations = PinboardDiskOperations()
  
  func fetchAllBookmarks(completion completion: BookmarkCompletion) {
    // Call the https://api.pinboard.in/v1/posts/update endpoint to get the last updated time
    do {
      try networkOperations.getLastUpdated { datetime in
        if let lastUpdated = self.diskOperations.lastUpdated {

          // Compare against the stored last updated time
          if  datetime != lastUpdated {

            // If they differ, fetch all bookmarks from server
            self.fetchAllBookmarksFromNetwork(completion: completion)
          } else {

            // If they are the same, fetch from data store
            self.diskOperations.fetchAllBookmarks(completion: completion)
            
            // If nothing is returned from disk, it means they don't have any bookmarks. We know this because the stored update date matches the network update date.
          }
        } else {
          self.diskOperations.lastUpdated = datetime
          self.fetchAllBookmarksFromNetwork(completion: completion)
        }
      }
    } catch {
      print(error)
    }
  }
  
  private func fetchAllBookmarksFromNetwork(completion completion: BookmarkCompletion) {
    do {
      try networkOperations.fetchAllBookmarks(completion: completion)
    } catch {
      print(error)
    }
  }
}
