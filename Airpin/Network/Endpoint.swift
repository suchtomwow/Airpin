//
//  Endpoint.swift
//  Airpin
//
//  Created by Thomas Carey on 4/7/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

struct Endpoint {
  let apiVersion = "v1"
  let path: String
  
  init(resourceTypes: [ResourceType]) {

    var resources: [Resource] = []
    resourceTypes.map { resources.append(Resource(resource: $0)) }
    
    path = resources.reduce("/" + apiVersion) { $0 + "/" + $1.resourcePath }
  }
}
