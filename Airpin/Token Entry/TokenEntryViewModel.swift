//
//  TokenEntryViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 4/15/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

class TokenEntryViewModel: BaseViewModel {
  var title: String {
    return "Settings"
  }
  
  let viewDetails = TokenEntryViewDetails()
  
  func store(token: String?) throws {
    if let token = token {
      let pinboardAccount = PinboardAccount(token: token)
      
      do {
        try pinboardAccount.storeInKeychain()
        NetworkClient.sharedInstance.pinboardAccount = pinboardAccount
      } catch {
        print(error)
      }
    }
  }
}
