//
//  SettingsControllerFactory.swift
//  Airpin
//
//  Created by Thomas Carey on 5/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import SafariServices

class SettingsControllerFactory {
    func makeSettingsController(accessToken: String) -> SettingsViewController {
        let viewModel = SettingsViewModel(accessToken: accessToken)
        return SettingsViewController(viewModel: viewModel)
    }

    func makeGetTokenController() -> SFSafariViewController {
        guard let url = URL(string: "https://m.pinboard.in/settings/password") else {
            fatalError("not able to parse URL")
        }

        return SFSafariViewController(url: url)
    }
}
