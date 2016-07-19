//
//  PinboardAccount.swift
//  Airpin
//
//  Created by Thomas Carey on 4/17/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

import Locksmith

struct PinboardAccount: GenericPasswordSecureStorable, CreateableSecureStorable, DeleteableSecureStorable {

  let username: String
  let password: String
  
  var token: String {
    let token = "\(username):\(password)"
    return token
  }
  
  init(account: String, password: String) {
    self.username = account
    self.password = password
  }
  
  init(token: String) {
    let components = token.components(separatedBy: ":")
    self.init(account: components[0], password: components[1])
  }
  
  // Required by GenericPasswordSecureStorable
  let service = Bundle.main().bundleIdentifier ?? "Airpin"

  var account: String {
    return username
  }
  
  // Required by CreateableSecureStorable
  var data: [String: AnyObject] {
    return ["password": password]
  }
  
  func storeInKeychain() throws {
    try createInSecureStore()
    storeUsernameInUserDefaults()
  }
  
  private func storeUsernameInUserDefaults() {
    let defaults = UserDefaults.standard()
    
    defaults.setValue(username, forKey: "pinboard_username")
    defaults.synchronize()
  }
  
  static func readFromKeychain() -> PinboardAccount? {
    let defaults = UserDefaults.standard()
    
    if let username = defaults.string(forKey: "pinboard_username"), let data = Locksmith.loadDataForUserAccount(userAccount: username), let password = data["password"] as? String {
      let account = PinboardAccount(account: username, password: password)

      return account
    } else {
      return nil
    }
  }
}
