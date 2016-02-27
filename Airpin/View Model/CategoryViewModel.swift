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
    case All, Unread, Untagged, Public, Private
    
    static let allValues = [All, Unread, Untagged, Public, Private]
    
    var description: String {
      switch self {
      case .All:      return "All"
      case .Unread:   return "Unread"
      case .Untagged: return "Untagged"
      case .Public:   return "Public"
      case .Private:  return "Private"
      }
    }
  }
  
  var title: String {
    return "Bookmarks"
  }
  
  var isLoggedIn: Bool {
    return NetworkClient.sharedInstance.accessToken != nil
  }
  
  var rightBarButtonText: String {
    return isLoggedIn ? "Log Out" : "Sign In"
  }
}
