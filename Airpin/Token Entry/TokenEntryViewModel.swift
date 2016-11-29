//
//  TokenEntryViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 4/15/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

import UIKit

class TokenEntryViewModel: BaseViewModel {
    var title = "Settings"
    
    let viewDetails = TokenEntryViewDetails()
    
    func store(token: String?) throws {
        if let token = token {
            let pinboardAccount = PinboardAccount(token: token)
            
            try pinboardAccount.storeInKeychain()
            NetworkClient.shared.pinboardAccount = pinboardAccount
        }
    }
    
    func loadAccount(token: String?) throws {
        if let token = token {
            let pinboardAccount = PinboardAccount(token: token)
            pinboardAccount.storeUsernameInUserDefaults()
            
            NetworkClient.shared.pinboardAccount = pinboardAccount
        }
    }
}
