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

class BookmarkViewModel: ViewModel {
  
  let category: CategoryViewModel.Category
  
  var bookmarks: Results<Bookmark>?
  
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
  
  private func fetchBookmarks(filter filter: NSPredicate?, completion: () -> Void) {
    dataProvider.fetchAllBookmarks {
      dispatch_async(dispatch_get_main_queue()) {
        var bookmarks = try! Realm().objects(Bookmark.self)
        
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
    let predicate = NSPredicate(format: "toRead == YES")
    fetchBookmarks(filter: predicate, completion: completion)
  }
  
  private func fetchUntaggedBookmarks(completion completion: () -> Void) {
    let predicate = NSPredicate(format: "userTags == %@", "")
    fetchBookmarks(filter: predicate, completion: completion)
  }
  
  private func fetchPublicBookmarks(completion completion: () -> Void) {
    let predicate = NSPredicate(format: "shared == YES")
    fetchBookmarks(filter: predicate, completion: completion)
  }
  
  private func fetchPrivateBookmarks(completion completion: () -> Void) {
    let predicate = NSPredicate(format: "shared == NO")
    fetchBookmarks(filter: predicate, completion: completion)
  }
}