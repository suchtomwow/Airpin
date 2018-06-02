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
        case popular, all, unread, untagged, `public`, `private`
        
        static let allValues = [popular, all, unread, untagged, `public`, `private`]
        static let loggedOutEnabled = [popular]
        
        var description: String {
            switch self {
            case .popular: return "Popular"
            case .all: return "All"
            case .unread: return "Unread"
            case .untagged: return "Untagged"
            case .public: return "Public"
            case .private: return "Private"
            }
        }
    }
    
    let title = "Categories"
    let isLoggedIn: Bool

    init(isLoggedIn: Bool) {
        self.isLoggedIn = isLoggedIn
    }
}
