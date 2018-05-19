//
//  SettingsViewController.swift
//  Airpin
//
//  Created by Thomas Carey on 5/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import Eureka

enum SettingsViewControllerOutput {
    case getToken
    case exitScreen(accessToken: String)
}

class SettingsViewController: FormViewController {

    var output: ((SettingsViewControllerOutput) -> Void)?

    private let enterTokenRow = TextRow()
    private let getTokenRow = ButtonRow()

    let viewModel: SettingsViewModel

    init(viewModel: SettingsViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        enterTokenRow.title = "Pinboard token"
        enterTokenRow.placeholder = "username:token"
        enterTokenRow.value = viewModel.accessToken

        getTokenRow.title = "Get token"
        getTokenRow.onCellSelection { [unowned self] _, _ in
            self.output?(.getToken)
        }

        title = viewModel.title

        configureForm()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        output?(.exitScreen(accessToken: enterTokenRow.value ?? ""))
    }

    private func configureForm() {
        var enterTokenSection = Section(footer: "Enter your Pinboard token to access your personal bookmarks.")
        enterTokenSection += [enterTokenRow]

        var getTokenSection = Section(footer: "After signing in, navigate to Settings > Password to find your Pinboard token.")
        getTokenSection += [getTokenRow]

        form +++ enterTokenSection +++ getTokenSection
    }
}
