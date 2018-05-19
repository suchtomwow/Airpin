//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

class AccessTokenLoader {
    func load() -> String {
        if let account = PinboardAccount.readFromKeychain() {
            NetworkClient.shared.pinboardAccount = account
            return account.token
        } else {
            return ""
        }
    }
}
