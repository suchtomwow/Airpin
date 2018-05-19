//
// Created by Thomas Carey on 5/19/18.
// Copyright © 2018 Thomas Carey. All rights reserved.
//

import UIKit

class BookmarkDetailsCoordinator {
    enum Output {
        case tappedGoToSettings
    }

    var output: ((Output) -> Void)?

    let presenter: Presenter
    let controllerFactory: BookmarkDetailsControllerFactory
    let interactor: BookmarkDetailsInteractor

    init(presenter: Presenter, controllerFactory: BookmarkDetailsControllerFactory = BookmarkDetailsControllerFactory(), interactor: BookmarkDetailsInteractor = BookmarkDetailsInteractor()) {
        self.presenter = presenter
        self.controllerFactory = controllerFactory
        self.interactor = interactor
    }

    func start() {
        interactor.getAccountStatus { [weak self] status in
            switch status {
            case .signedIn:
                self?.presentAddBookmark()
            case .notSignedIn:
                self?.presentSignInModal()
            }
        }
    }

    func presentAddBookmark() {
        let controller = controllerFactory.makeAddBookmarkController()
        let nav = UINavigationController(rootViewController: controller)

        controller.output = { [weak self] output in
            switch output {
            case .bookmarkAdded:
                self?.presenter.dismiss(animated: true, completion: nil)
            }
        }

        presenter.present(nav, animated: true, completion: nil)
    }

    func presentSignInModal() {
        let controller = controllerFactory.makeSignInModal()

        controller.output = { [unowned self] output in
            switch output {
            case .tappedButton:
                self.output?(.tappedGoToSettings)
            }
        }
        presenter.present(controller, animated: true, completion: nil)
    }
}
