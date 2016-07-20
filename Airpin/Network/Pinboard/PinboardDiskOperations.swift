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
    var lastUpdated: Date? {
        get {
            return UserDefaults.standard().object(forKey: UserDefault.UpdateTime.rawValue) as? Date
        }
        set {
            UserDefaults.standard().set(newValue, forKey: UserDefault.UpdateTime.rawValue)
        }
    }
    
    func fetchAllBookmarks(completion: BookmarkCompletion) {
        completion()
    }
}
