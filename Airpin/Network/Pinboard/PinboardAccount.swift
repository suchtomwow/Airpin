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
    
    let userDefaultsManager: UserDefaultsManager

    init?(token: String, userDefaultsManager: UserDefaultsManager = UserDefaults.standard) {
        let components = token.components(separatedBy: ":")
        guard components.count == 2 else { return nil }

        username = components[0]
        password = components[1]
        self.userDefaultsManager = userDefaultsManager
    }

    init(account: String, password: String, userDefaultsManager: UserDefaultsManager = UserDefaults.standard) {
        self.username = account
        self.password = password
        self.userDefaultsManager = userDefaultsManager
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
        userDefaultsManager.set(username, forKey: UserDefault.pinboardUsername)
        userDefaultsManager.synchronize()
    }
    
    static func readFromKeychain(userDefaultsManager: UserDefaultsManager = UserDefaults.standard) -> PinboardAccount? {
        if let username = userDefaultsManager.string(forKey: UserDefault.pinboardUsername),
            let data = Locksmith.loadDataForUserAccount(userAccount: username, inService: KeychainServiceIdentifier),
            let password = data[PasswordKey] as? String {
            
            let account = PinboardAccount(account: username, password: password)
            
            return account
        } else {
            return nil
        }
    }

    static func deleteFromSecureStore(userDefaultsManager: UserDefaultsManager = UserDefaults.standard) {
        if let username = userDefaultsManager.string(forKey: UserDefault.pinboardUsername) {
            do {
                try Locksmith.deleteDataForUserAccount(userAccount: username)
                userDefaultsManager.set(nil, forKey: UserDefault.pinboardUsername)
            } catch {
                NSLog(error.localizedDescription)
            }
        }
    }
}
