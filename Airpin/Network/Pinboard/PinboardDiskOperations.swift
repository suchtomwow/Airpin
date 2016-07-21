//
//  PinboardDiskOperations.swift
//  Airpin
//
//  Created by Thomas Carey on 7/22/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import Foundation

class PinboardDiskOperations {
    var lastUpdated: Date? {
        get {
            return UserDefaults.standard.object(forKey: UserDefault.updateTime.rawValue) as? Date
        }
        set {
            UserDefaults.standard.set(newValue, forKey: UserDefault.updateTime.rawValue)
        }
    }
    
    func fetchAllBookmarks(completion: BookmarkCompletion) {
        completion()
    }
}
