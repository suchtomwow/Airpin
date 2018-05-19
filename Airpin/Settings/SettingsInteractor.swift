//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

import Foundation

class SettingsInteractor {

    let accessTokenLoader = AccessTokenLoader()
    let accessTokenStorer = AccessTokenStorer()

    func loadAccessToken() -> String {
        return accessTokenLoader.load()
    }

    func storeAccessToken(_ accessToken: String) {
        accessTokenStorer.store(accessToken)
    }
}
