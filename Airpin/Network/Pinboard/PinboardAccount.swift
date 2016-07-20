//
//  PinboardAccount.swift
//  Airpin
//
//  Created by Thomas Carey on 4/17/16.
//  Copyright © 2016 Thomas Carey. All rights reserved.
//

import Locksmith

let PasswordDefine = "password"
let KeychainServiceIdentifier = Bundle.main().bundleIdentifier ?? "Airpin"

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
    
    let service = KeychainServiceIdentifier
    
    var account: String {
        return username
    }
    
    var data: [String: AnyObject] {
        return [PasswordDefine: password]
    }
    
    func storeInKeychain() throws {
        try createInSecureStore()
        storeUsernameInUserDefaults()
    }
    
    func storeUsernameInUserDefaults() {
        let defaults = UserDefaults.standard()
        
        defaults.setValue(username, forKey: UserDefault.PinboardUsername.rawValue)
        defaults.synchronize()
    }
    
    static func readFromKeychain() -> PinboardAccount? {
        let defaults = UserDefaults.standard()
        
        if let username = defaults.string(forKey: UserDefault.PinboardUsername.rawValue),
           let data = Locksmith.loadDataForUserAccount(userAccount: username, inService: KeychainServiceIdentifier),
           let password = data[PasswordDefine] as? String {
            
            let account = PinboardAccount(account: username, password: password)
            
            return account
        } else {
            return nil
        }
    }
}
