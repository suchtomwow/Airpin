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
    
    private func urlComponents(with baseURL: String) -> URLComponents {
        var components        = URLComponents()
        components.scheme     = self.scheme
        components.host       = baseURL
        components.queryItems = [self.formatQueryItem]

        return components
    }
    
    lazy var sessionConfig: URLSessionConfiguration = {
        let sessionConfig                       = URLSessionConfiguration.default
        sessionConfig.httpAdditionalHeaders     = ["Accept": "application/json"]
        sessionConfig.timeoutIntervalForRequest = 30.0
        
        return sessionConfig
    }()
    
    let formatQueryItem = URLQueryItem(name: "format", value: "json")
    
    func executeRequest(with baseURL: String, endpoint: Endpoint, parameters: [URLQueryItem]? = nil, completion: ((Result<JSON>, _ user: String?) -> Void)?) {
        var components = urlComponents(with: baseURL)

        if let parameters = parameters {
            components.queryItems?.append(contentsOf: parameters)
        }

        var url = components.url
        if baseURL == Endpoint.DefaultBaseURL {
            url = url?.appendingPathComponent("v1")
        }

        url = url?.appendingPathComponent(endpoint.path)
        var request = URLRequest(url: url!)

        request.setValue("Bearer thomasjcarey:2cff43a9ac56dd12fa89", forHTTPHeaderField: "Authorization")
        if let accessToken = accessToken {
        }
        
        let session = URLSession(configuration: sessionConfig)
        
        let dataTask = session.dataTask(with: request) { [weak self] data, response, error in
            if let error = error {
                print(error)
            } else if let data = data, let response = response as? HTTPURLResponse {
                if response.statusCode == StatusCode.ok.rawValue, let json = try? JSON(data: data) {
                    completion?(Result.success(json), self?.pinboardAccount?.username)
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
