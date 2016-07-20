//
//  Resource.swift
//  Airpin
//
//  Created by Thomas Carey on 4/8/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

enum ResourceType: String {
    case APIToken = "api_token"
    case add      = "add"
    case all      = "all"
    case dates    = "dates"
    case delete   = "delete"
    case get      = "get"
    case list     = "list"
    case notes    = "notes"
    case posts    = "posts"
    case recent   = "recent"
    case rename   = "rename"
    case secret   = "secret"
    case suggest  = "suggest"
    case tags     = "tags"
    case update   = "update"
    case user     = "user"
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
