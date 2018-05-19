//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

import Foundation

class SettingsViewModel: BaseViewModel {

    var title: String = "Settings"
    var accessToken: String?

    init(accessToken: String?) {
        self.accessToken = accessToken
    }
}
