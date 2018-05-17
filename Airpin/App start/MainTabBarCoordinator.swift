//
//  MainTabBarCoordinator.swift
//  Airpin
//
//  Created by Thomas Carey on 5/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import UIKit

class MainTabBarCoordinator {

    weak private var window: UIWindow?
    
    private let rootControllerFactory: RootControllerFactory
    private let bookmarkListControllerFactory: BookmarkListControllerFactory
    private let bookmarkDetailsControllerFactory: BookmarkDetailsControllerFactory
    private let settingsControllerFactory: SettingsControllerFactory

    private var presenterType: Presenter.Type
    private var presenter: Presenter?

    init(window: UIWindow,
         rootControllerFactory: RootControllerFactory,
         bookmarkListControllerFactory: BookmarkListControllerFactory,
         bookmarkDetailsControllerFactory: BookmarkDetailsControllerFactory,
         settingsControllerFactory: SettingsControllerFactory,
         presenterType: Presenter.Type) {
        self.window = window
        self.rootControllerFactory = rootControllerFactory
        self.bookmarkListControllerFactory = bookmarkListControllerFactory
        self.bookmarkDetailsControllerFactory = bookmarkDetailsControllerFactory
        self.settingsControllerFactory = settingsControllerFactory
        self.presenterType = presenterType
    }

    func start() {
        let rootController = rootControllerFactory.makeRootController(bookmarkListControllerFactory: bookmarkListControllerFactory,
                                                                      bookmarkDetailsControllerFactory: bookmarkDetailsControllerFactory,
                                                                      settingsControllerFactory: settingsControllerFactory)

        presenter = presenterType.init(presenter: rootController)

        rootController.output = { [unowned self] output in
            switch output {
            case .addBookmark:
                self.presentAddBookmark()
            }
        }

        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
    }

    private func presentAddBookmark() {
        let controller = bookmarkDetailsControllerFactory.makeAddBookmarkController()
        let nav = UINavigationController(rootViewController: controller)

        controller.output = { [weak self] output in
            switch output {
            case .bookmarkAdded:
                self?.presenter?.dismiss(animated: true, completion: nil)
            }
        }

        presenter?.present(nav, animated: true, completion: nil)
    }
}
