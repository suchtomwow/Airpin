//
//  Static.swift
//  Airpin
//
//  Created by Thomas Carey on 7/21/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import Foundation

class Formatter {
   static var JSON: NSDateFormatter {
    let formatter = NSDateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
    
    return formatter
  }
  
  static var humanTime: NSDateFormatter {
    let formatter = NSDateFormatter()
    formatter.timeStyle = .NoStyle
    formatter.dateStyle = .MediumStyle
    formatter.doesRelativeDateFormatting = true
    
    return formatter
  }
}
