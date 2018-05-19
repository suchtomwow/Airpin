//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

import UIKit

class SettingsCoordinator {

    var presenter: Presenter?
    let settingsControllerFactory: SettingsControllerFactory
    let interactor: SettingsInteractor

    init(settingsControllerFactory: SettingsControllerFactory, interactor: SettingsInteractor = SettingsInteractor()) {
        self.settingsControllerFactory = settingsControllerFactory
        self.interactor = interactor
    }

    func start() -> UIViewController {
        let accessToken = interactor.loadAccessToken()
        let controller = settingsControllerFactory.makeSettingsController(accessToken: accessToken)

        controller.output = { [unowned self] output in
            switch output {
            case .getToken:
                self.presentGetToken()
            case .exitScreen(let accessToken):
                self.interactor.storeAccessToken(accessToken)
            }
        }

        presenter = PresenterImplementation(presenter: controller)

        return UINavigationController(rootViewController: controller)
    }

    func presentGetToken() {
        let controller = settingsControllerFactory.makeGetTokenController()
        presenter?.present(controller, animated: true, completion: nil)
    }
}
