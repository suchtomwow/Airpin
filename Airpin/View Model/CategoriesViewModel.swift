//
//  CategoriesViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 4/16/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

struct CategoriesViewModel: ViewModel {
  enum Category: String {
    case All      = "All"
    case Unread   = "Unread"
    case Starred  = "Starred"
    case Untagged = "Untagged"
    case Public   = "Public"
    case Private  = "Private"
    
    static let allValues = [All, Unread, Starred, Untagged, Public, Private]
  }
  
  var title: String {
    return "Bookmarks"
  }
  
  var rightBarButtonText: String {
    return "Sign In"
  }
}
