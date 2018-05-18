//
//  SettingsViewController.swift
//  Airpin
//
//  Created by Thomas Carey on 5/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import Eureka
import SafariServices

class SettingsViewController: FormViewController {
    private let entertokenRow = TextRow()
    private let getTokenRow = ButtonRow()

    override func viewDidLoad() {
        super.viewDidLoad()

        entertokenRow.title = "Pinboard token"
        entertokenRow.placeholder = "username:token"
        getTokenRow.title = "Get token"

        getTokenRow.onCellSelection { [unowned self] _, _ in
            guard let url = URL(string: "https://m.pinboard.in/settings/password") else {
                return
            }

            let svc = SFSafariViewController(url: url)
            self.present(svc, animated: true, completion: nil)
        }

        configureForm()
    }

    private func configureForm() {
        var enterTokenSection = Section(footer: "Enter your Pinboard token to access your personal bookmarks.")
        enterTokenSection += [entertokenRow]

        var getTokenSection = Section(footer: "After signing in, navigate to Settings > Password to find your Pinboard token.")
        getTokenSection += [getTokenRow]

        form +++ enterTokenSection +++ getTokenSection
    }
}
