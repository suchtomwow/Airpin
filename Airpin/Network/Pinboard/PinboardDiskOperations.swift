//
//  PinboardDiskOperations.swift
//  Airpin
//
//  Created by Thomas Carey on 7/22/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import Foundation

struct PinboardDiskOperations {
  var lastUpdated: NSDate {
    get {
      return NSUserDefaults.standardUserDefaults().objectForKey(UserDefault.UpdateTime.rawValue) as! NSDate
    }
    set {
      NSUserDefaults.standardUserDefaults().setObject(newValue, forKey: UserDefault.UpdateTime.rawValue)
    }
  }
}