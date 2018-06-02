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
        return "urlString"
    }

    @objc dynamic var user: String = ""
    @objc dynamic var pbHash: String = "" // API: "hash", unique identifier
    @objc dynamic var urlString: String = "" // API: "href"
    @objc dynamic var title: String = "" // API: "description", max 256 characters
    @objc dynamic var extended: String = "" // API: "extended", max 65536 characters
    @objc dynamic var meta: String = "" // API: "meta", if different than stored, update
    @objc dynamic var datetime: Date = Date() // API: "time"
    @objc dynamic var shared: Bool = false // API: "shared", private/public
    @objc dynamic var toRead: Bool = false // API: "toread"
    let tags = List<Tag>() // API: "tags", space delimited list of words

    /// This is less dumb than it looks. If you implement an intializer to do the same thing, then you have to override a normal init as well as an init with Realm, which if you have time to figure out how to do, go for it.
    class func fromAPI(json: JSON, username: String?) -> Bookmark {
        let bookmark = Bookmark()
        bookmark.user = username ?? bookmark.user
        bookmark.pbHash = json["hash"].stringValue
        bookmark.urlString = json["href"].stringValue
        bookmark.title = json["description"].stringValue
        bookmark.extended = json["extended"].stringValue
        bookmark.meta = json["meta"].stringValue
        bookmark.datetime = Formatter.JSON.date(from: json["time"].stringValue)!
        bookmark.shared = Bool(string: json["shared"].stringValue)
        bookmark.toRead = Bool(string: json["toread"].stringValue)
        json["tags"].stringValue.split(separator: " ").forEach {
            let tag = Tag(value: [$0])
            bookmark.tags.append(tag)
        }
        
        return bookmark
    }

    class func fromRSS(json: JSON) -> Bookmark {
        let bookmark = Bookmark()
        bookmark.urlString = json["u"].stringValue
        bookmark.title = json["d"].stringValue
        bookmark.extended = json["n"].stringValue
        bookmark.datetime = Formatter.JSON.date(from: json["dt"].stringValue)!
        bookmark.toRead = true

        let tags = json["t"].arrayObject?
            .filter { !String(describing: $0).isEmpty }
            .map { Tag(value: [$0]) }
            ?? []

        bookmark.tags.append(objectsIn: tags)

        return bookmark
    }
    
    override static func ignoredProperties() -> [String] {
        return ["url", "displayURL", "readState"]
    }
    
    func persist(in realmConfiguration: Realm.Configuration) {
        do {
            let realm = try Realm(configuration: realmConfiguration)
            try realm.write {
                realm.add(self, update: true)
            }
        } catch {
            NSLog(error.localizedDescription)
        }
    }
    
    var url: Foundation.URL {
        set {
            urlString = newValue.absoluteString
        }
        get {
            return URL(string: urlString.trim())!
        }
    }
    
    var displayURL: String {
        return url.host!
    }
}

// MARK: Convenience

enum ReadState {
    case read, unread
}

extension Bookmark {
    var readState: ReadState {
        return toRead == true ? .unread : .read
    }
}
