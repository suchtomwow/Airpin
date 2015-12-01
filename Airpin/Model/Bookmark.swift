//
//  Bookmark.swift
//  Airpin
//
//  Created by Thomas Carey on 4/17/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import Foundation
import RealmSwift
import SwiftyJSON

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

class Bookmark: Object {
  
  override static func primaryKey() -> String? {
    return "pbHash"
  }
  
  dynamic var pbHash:   String = ""// API: "hash", unique identifier
  dynamic var url:      String = ""// API: "href"
  dynamic var title:    String = ""// API: "description", max 256 characters
  dynamic var desc:     String = ""// API: "extended", max 65536 characters
  dynamic var meta:     String = ""// API: "meta", if different than stored, update
  dynamic var datetime: NSDate = NSDate(timeIntervalSince1970: 1)// API: "time"
  dynamic var shared:   Bool   = false// API: "shared", private/public
  dynamic var toRead:   Bool   = false// API: "toread"
  dynamic var userTags: String = ""// API: "tags", space delimited list of words
  
  class func fromJSON(json: JSON) -> Bookmark {
    let bookmark      = Bookmark()
    bookmark.pbHash   = json["hash"].stringValue
    bookmark.url      = json["href"].stringValue
    bookmark.title    = json["description"].stringValue
    bookmark.desc     = json["extended"].stringValue
    bookmark.meta     = json["meta"].stringValue
    bookmark.datetime = Formatter.JSON.dateFromString(json["time"].stringValue)!
    bookmark.shared   = Bool(string: json["shared"].stringValue)
    bookmark.toRead   = Bool(string: json["toread"].stringValue)
    bookmark.userTags  = json["tags"].stringValue
    
    return bookmark
  }

  func persist() {
    do {
      let realm = try Realm()
      
      try realm.write {
        realm.add(self, update: true)
      }
    } catch {
      print(error)
    }
  }
}

// MARK: Convenience

enum ReadState {
  case Read, Unread
}

extension Bookmark {
  var readState: ReadState {
    return toRead == true ? .Unread : .Read
  }
  
  var tagsArray: [String] {
    return userTags.characters.split(" ").map { String($0) }
  }
}