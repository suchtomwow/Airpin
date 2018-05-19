//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

import Foundation

class AccessTokenStorer {
    func store(_ accessToken: String) {
        if let account = PinboardAccount(token: accessToken) {
            do {
                try account.storeInKeychain()
                NetworkClient.shared.pinboardAccount = account
            } catch {
                NSLog(error.localizedDescription)
            }
        } else {
            PinboardAccount.deleteFromSecureStore()
            NetworkClient.shared.pinboardAccount = nil
        }
    }
}
