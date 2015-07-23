//
//  Bookmark.swift
//  Airpin
//
//  Created by Thomas Carey on 4/17/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import Foundation

struct Bookmark {
  let url: String           // API: "href"
  let title: String         // API: "description", max 256 characters
  let description: String   // API: "extended", max 65536 characters
  let meta: String          // API: "meta", UUID (?)
  let datetime: NSDate      // API: "time"
  let shared: Bool          // API: "shared", private/public
  let toRead: Bool          // API: "toread"
  let tags: [String]        // API: "tags", space delimited list of words
  
  init(json: JSON) {
    url         = json["href"] as! String
    title       = json["description"] as! String
    description = json["extended"] as! String
    meta        = json["meta"] as! String
    datetime    = Formatter.JSON.dateFromString(json["time"] as! String)!
    shared      = Bool(string: json["shared"] as! String)
    toRead      = Bool(string: json["toread"] as! String)
    tags        = (json["tags"] as! String).componentsSeparatedByString(" ")
  }
  
/**
  {
      "href": "http:\/\/www.raizlabs.com\/dev\/2015\/03\/spicing-up-xcode\/",
      "description": "Spicing Up Xcode - 13 Tips and Tricks About XcodeRaizException \u2013 Raizlabs developer blog",
      "extended": "Amazing Xcode tips and tricks",
      "meta": "06692cff56aaf7974d061464724265e7",
      "hash": "37db02fb2c87826f33b551b510a243c7",
      "time": "2015-03-20T20:49:16Z",
      "shared": "yes",
      "toread": "no",
      "tags": "xcode ios development"
  }
*/
}