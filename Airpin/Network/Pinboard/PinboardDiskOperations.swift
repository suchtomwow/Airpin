//
//  PinboardDiskOperations.swift
//  Airpin
//
//  Created by Thomas Carey on 7/22/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import Foundation
import RealmSwift

class PinboardDiskOperations {
  var lastUpdated: NSDate? {
    get {
      return NSUserDefaults.standardUserDefaults().objectForKey(UserDefault.UpdateTime.rawValue) as? NSDate
    }
    set {
      NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: UserDefault.UpdateTime.rawValue)
    }
  }
  
  func fetchAllBookmarks(completion completion: BookmarkCompletion) {
    completion()
  }
}