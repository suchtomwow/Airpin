//
//  Resource.swift
//  Airpin
//
//  Created by Thomas Carey on 4/8/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

enum ResourceType: String {
  case APIToken = "api_token"
  case All      = "all"
  case Dates    = "dates"
  case Delete   = "delete"
  case Get      = "get"
  case List     = "list"
  case Notes    = "notes"
  case Posts    = "posts"
  case Recent   = "recent"
  case Rename   = "rename"
  case Secret   = "secret"
  case Suggest  = "suggest"
  case Tags     = "tags"
  case Update   = "update"
  case User     = "user"
}

struct Resource {
  let resource: ResourceType
  var id: String?
  
  var resourcePath: String {
    if let resourceID = id {
      return resource.rawValue + "\(resourceID)"
    } else {
      return resource.rawValue
    }
  }
  
  init(resource: ResourceType, id: String? = nil) {
    self.resource = resource
    self.id = id
  }
}