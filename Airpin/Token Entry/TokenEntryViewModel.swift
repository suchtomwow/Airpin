//
//  TokenEntryViewModel.swift
//  Airpin
//
//  Created by Thomas Carey on 4/15/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

import UIKit

enum TokenEntry: Error {
    case incorrectFormat
}

class TokenEntryViewModel: BaseViewModel {

    struct TokenComponents {
        let account: String
        let password: String
    }

    var title = "Settings"
    
    let viewDetails = TokenEntryViewDetails()

    func store(token: String?) throws {
        if let token = token {
            let components = token.components(separatedBy: ":")
            guard components.count == 2 else { throw TokenEntry.incorrectFormat }

            let pinboardAccount = PinboardAccount(account: components[0], password: components[1])
            
            try pinboardAccount.storeInKeychain()
            NetworkClient.shared.pinboardAccount = pinboardAccount
        }
    }
    
    func loadAccount(token: String?) throws {
        if let token = token {
            let components = token.components(separatedBy: ":")
            guard components.count == 2 else { throw TokenEntry.incorrectFormat }

            let pinboardAccount = PinboardAccount(account: components[0], password: components[1])

            pinboardAccount.storeUsernameInUserDefaults()
            
            NetworkClient.shared.pinboardAccount = pinboardAccount
        }
    }
}
