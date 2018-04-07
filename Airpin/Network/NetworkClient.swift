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
    case success(T)
    case failure(NSError)
}

class NetworkClient {
    static let shared = NetworkClient()
    
    let scheme = "https"
    let host   = "api.pinboard.in"
    
    var accessToken: String? {
        let token = pinboardAccount?.token
        return token
    }
    
    lazy var pinboardAccount: PinboardAccount? = {
        let account = PinboardAccount.readFromKeychain()
        return account
    }()
    
    func signOut(completion: () -> ()) {
        do {
            try pinboardAccount?.deleteFromSecureStore()
            pinboardAccount = nil
            completion()
        } catch {
            print(error)
        }
    }
    
    lazy var components: URLComponents = {
        var components        = URLComponents()
        components.scheme     = self.scheme
        components.host       = self.host
        components.queryItems = [self.authTokenQueryItem, self.formatQueryItem]
        
        return components
    }()
    
    lazy var sessionConfig: URLSessionConfiguration = {
        let sessionConfig                       = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders     = ["Accept": "application/json"]
        sessionConfig.timeoutIntervalForRequest = 30.0
        
        return sessionConfig
    }()
    
    var authTokenQueryItem: URLQueryItem {
        return URLQueryItem(name: "auth_token", value: accessToken)
    }
    
    let formatQueryItem = URLQueryItem(name: "format", value: "json")
    
    func executeRequest(with endpoint: Endpoint, parameters: [URLQueryItem]? = nil, completion: ((Result<JSON>) -> Void)?) {
        if let parameters = parameters {
            components.queryItems?.append(contentsOf: parameters)
        }
        
        let url = components.url?.appendingPathComponent(endpoint.path)
        let request = URLRequest(url: url!)
        
        let session = URLSession(configuration: sessionConfig)
        
        let dataTask = session.dataTask(with: request) { data, response, error in
            if let error = error {
                print(error)
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == StatusCode.ok.rawValue, let json = try? JSON(data: data) {
                    completion?(Result.success(json))
                }
            }
        }
        
        dataTask.resume()
    }
}

enum StatusCode: Int {
    case ok           = 200
    case created      = 201
    case accepted     = 202
    case badRequest   = 400
    case unauthorized = 401
    case forbidden    = 403
    case notFound     = 404
    case serverError  = 500
    case badGateway   = 502
}
