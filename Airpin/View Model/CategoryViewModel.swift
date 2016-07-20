//
//  CategoryViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit

class CategoryViewModel: BaseViewModel {
    enum Category: Int, CustomStringConvertible {
        case all, unread, untagged, `public`, `private`
        
        static let allValues = [all, unread, untagged, `public`, `private`]
        
        var description: String {
            switch self {
            case .all:      return "All"
            case .unread:   return "Unread"
            case .untagged: return "Untagged"
            case .public:   return "Public"
            case .private:  return "Private"
            }
        }
    }
    
    var title: String {
        return "Bookmarks"
    }
    
    var isLoggedIn: Bool {
        let isLoggedIn = NetworkClient.sharedInstance.accessToken != nil
        return isLoggedIn
    }
    
    var rightBarButtonText: String {
        return isLoggedIn ? "Sign out" : "Sign in"
    }
}
