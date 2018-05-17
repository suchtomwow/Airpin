//
//  Endpoint.swift
//  Airpin
//
//  Created by Thomas Carey on 4/7/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

struct Endpoint {
    static let DefaultBaseURL = "api.pinboard.in"
    static let RSSBaseURL = "feeds.pinboard.in"

    let path: String
    
    init(resourceTypes: [ResourceType]) {
        
        var resources: [Resource] = []
        resourceTypes.forEach { resources.append(Resource(resource: $0)) }
        
        path = resources.reduce("") { $0 + "/" + $1.resourcePath }
    }
}
