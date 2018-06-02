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
    private let bookmarkListCoordinatorFactory: BookmarkListCoordinatorFactory
    private let bookmarkDetailsControllerFactory: BookmarkDetailsControllerFactory
    private let settingsCoordinatorFactory: SettingsCoordinatorFactory

    private var presenterType: Presenter.Type
    private var presenter: Presenter?

    private var rootController: MainTabBarController!
    private var bookmarkDetailsCoordinator: BookmarkDetailsCoordinator?

    init(window: UIWindow,
         rootControllerFactory: RootControllerFactory,
         bookmarkListCoordinatorFactory: BookmarkListCoordinatorFactory,
         bookmarkDetailsControllerFactory: BookmarkDetailsControllerFactory,
         settingsCoordinatorFactory: SettingsCoordinatorFactory,
         presenterType: Presenter.Type) {
        self.window = window
        self.rootControllerFactory = rootControllerFactory
        self.bookmarkListCoordinatorFactory = bookmarkListCoordinatorFactory
        self.bookmarkDetailsControllerFactory = bookmarkDetailsControllerFactory
        self.settingsCoordinatorFactory = settingsCoordinatorFactory
        self.presenterType = presenterType
    }

    func start() {
        rootController = rootControllerFactory.makeRootController(bookmarkListCoordinatorFactory: bookmarkListCoordinatorFactory,
                                                                  bookmarkDetailsControllerFactory: bookmarkDetailsControllerFactory,
                                                                  settingsCoordinatorFactory: settingsCoordinatorFactory)

        presenter = presenterType.init(presenter: rootController)

        rootController.output = { [unowned self] output in
            switch output {
            case .addBookmark:
                self.startAddBookmarkCoordinator()
            case .tappedGoToSettings:
                self.goToSettings()
            }
        }

        window?.rootViewController = rootController
        window?.makeKeyAndVisible()
    }

    private func startAddBookmarkCoordinator() {
        guard let presenter = presenter else { return }
        bookmarkDetailsCoordinator = BookmarkDetailsCoordinator(presenter: presenter, controllerFactory: bookmarkDetailsControllerFactory)

        bookmarkDetailsCoordinator?.output = { [weak self] output in
            switch output {
            case .tappedGoToSettings:
                self?.goToSettings()
            }
        }

        bookmarkDetailsCoordinator?.start()
    }

    func goToSettings() {
        guard let settingsController = rootController.viewControllers?.filter({ ($0 as? UINavigationController)?.topViewController is SettingsViewController }).first else { return }
        rootController.selectedViewController = settingsController
    }
}
