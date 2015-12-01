//
//  NetworkClient.swift
//  Airpin
//
//  Created by Thomas Carey on 4/7/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import Foundation
import SwiftyJSON

enum Result<T> {
  case Success(T)
  case Failure(NSError)
}

class NetworkClient {
  static let sharedInstance = NetworkClient()
  
  let scheme               = "https"
  let host                 = "api.pinboard.in"
  let accessToken: String? = "thomasjcarey:2cff43a9ac56dd12fa89"
  
  lazy var components: NSURLComponents = {
    let components        = NSURLComponents()
    components.scheme     = self.scheme
    components.host       = self.host
    components.queryItems = [self.authTokenQueryItem, self.formatQueryItem]
    
    return components
  }()
  
  lazy var sessionConfig: NSURLSessionConfiguration = {
    let sessionConfig                       = NSURLSessionConfiguration.defaultSessionConfiguration()
    sessionConfig.HTTPAdditionalHeaders     = ["Accept": "application/json"]
    sessionConfig.timeoutIntervalForRequest = 30.0
    
    return sessionConfig
  }()
  
  var authTokenQueryItem: NSURLQueryItem {
    return NSURLQueryItem(name: "auth_token", value: accessToken)
  }
  
  let formatQueryItem    = NSURLQueryItem(name: "format", value: "json")
  
  func executeRequest(endpoint: Endpoint, parameters: [NSURLQueryItem]? = nil, completion: (Result<JSON> -> Void)?) {
    if let parameters = parameters {
      components.queryItems?.appendContentsOf(parameters)
    }
    
    let url     = components.URL?.URLByAppendingPathComponent(endpoint.path)
    let request = NSURLRequest(URL: url!)
    
    let session = NSURLSession(configuration: sessionConfig)

    let dataTask = session.dataTaskWithRequest(request) { data, response, error in
      if let error = error {
        print(error)
      } else if let data = data, response = response as? NSHTTPURLResponse {
        if response.statusCode == StatusCode.OK.rawValue {
          let json = JSON(data: data)          
          completion?(Result.Success(json))
        }
      }
    }
    
    dataTask.resume()
  }
}

enum StatusCode: Int {
  case OK           = 200
  case Created      = 201
  case Accepted     = 202
  case BadRequest   = 400
  case Unauthorized = 401
  case Forbidden    = 403
  case NotFound     = 404
  case ServerError  = 500
  case BadGateway   = 502
}
