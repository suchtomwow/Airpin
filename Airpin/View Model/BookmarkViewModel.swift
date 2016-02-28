//
//  BookmarkViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 10/10/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import Foundation
import RealmSwift
import UIKit

class BookmarkViewModel: BaseViewModel {
  
  let category: CategoryViewModel.Category
  
  var bookmarks: [Bookmark]?
  
  let dataProvider = PinboardDataProvider()
  
  var title: String {
    return category.description
  }
  
  init(category: CategoryViewModel.Category) {
    self.category = category
  }
  
  func fetchBookmarks(completion completion: () -> Void) {
    switch category {
    case .All:
      fetchAllBookmarks(completion: completion)
    case .Unread:
      fetchUnreadBookmarks(completion: completion)
    case .Untagged:
      fetchUntaggedBookmarks(completion: completion)
    case .Public:
      fetchPublicBookmarks(completion: completion)
    case .Private:
      fetchPrivateBookmarks(completion: completion)
    }
  }
  
  private func fetchBookmarks(filter filter: ((bookmark: Bookmark) -> Bool)?, completion: () -> Void) {
    dataProvider.fetchAllBookmarks {
      dispatch_async(dispatch_get_main_queue()) {
        // Need to map these to a regular [Bookmark] because the default value is Results<Bookmark>, which is auto-updating.
        // Because it is auto-updating, rows are removed from the tableView when I still want to be able to display them to the user.
        var bookmarks = try! Realm().objects(Bookmark.self).map { $0 }
        
        if let filter = filter {
          bookmarks = bookmarks.filter(filter)
        }
        
        self.bookmarks = bookmarks
        completion()
      }
    }
  }
  
  private func fetchAllBookmarks(completion completion: () -> Void) {
    fetchBookmarks(filter: nil, completion: completion)
  }
  
  private func fetchUnreadBookmarks(completion completion: () -> Void) {
    fetchBookmarks(filter: { $0.toRead }, completion: completion)
  }
  
  private func fetchUntaggedBookmarks(completion completion: () -> Void) {
    fetchBookmarks(filter: { $0.tagsArray.count == 0 }, completion: completion)
  }
  
  private func fetchPublicBookmarks(completion completion: () -> Void) {
    fetchBookmarks(filter: { $0.shared }, completion: completion)
  }
  
  private func fetchPrivateBookmarks(completion completion: () -> Void) {
    fetchBookmarks(filter: { !$0.shared }, completion: completion)
  }
  
  func markBookmarkAsReadAtIndex(index: Int) {
    dataProvider.markBookmarkAsRead(bookmarks![index])
  }
}