//
//  PinboardAccount.swift
//  Airpin
//
//  Created by Thomas Carey on 4/17/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

import Locksmith

let KeychainServiceIdentifier = Bundle.main.bundleIdentifier!

struct PinboardAccount: GenericPasswordSecureStorable, CreateableSecureStorable, DeleteableSecureStorable {
    let username: String
    let password: String
    
    static let PasswordKey = "password"
    
    var token: String {
        let token = "\(username):\(password)"
        return token
    }
    
    init(account: String, password: String) {
        self.username = account
        self.password = password
    }
    
    let service = KeychainServiceIdentifier
    
    var account: String {
        return username
    }
    
    var data: [String: Any] {
        return [PinboardAccount.PasswordKey: password]
    }
    
    func storeInKeychain() throws {
        try createInSecureStore()
        storeUsernameInUserDefaults()
    }
    
    func storeUsernameInUserDefaults() {
        let defaults = UserDefaults.standard
        
        defaults.setValue(username, forKey: UserDefault.pinboardUsername)
        defaults.synchronize()
    }
    
    static func readFromKeychain() -> PinboardAccount? {
        let defaults = UserDefaults.standard
        
        if let username = defaults.string(forKey: UserDefault.pinboardUsername),
            let data = Locksmith.loadDataForUserAccount(userAccount: username, inService: KeychainServiceIdentifier),
            let password = data[PasswordKey] as? String {
            
            let account = PinboardAccount(account: username, password: password)
            
            return account
        } else {
            return nil
        }
    }
}
