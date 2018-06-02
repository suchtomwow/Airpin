//
//  MainTabBarController.swift
//  Airpin
//
//  Created by Thomas Carey on 5/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import UIKit

struct MainViewControllers {
    let bookmarkListCoordinator: BookmarkListCoordinator
    let addStubController: UIViewController
    let settingsCoordinator: SettingsCoordinator
}

enum MainTabBarControllerPresentableOutput {
    case addBookmark, tappedGoToSettings
}

protocol MainTabBarControllerPresentable {
    var output: ((MainTabBarControllerPresentableOutput) -> Void)? { get set }
}

class MainTabBarController: UITabBarController {

    var output: ((MainTabBarControllerPresentableOutput) -> Void)?

    fileprivate let mainViewControllers: MainViewControllers

    init(bookmarkListCoordinatorFactory: BookmarkListCoordinatorFactory,
         bookmarkDetailsControllerFactory: BookmarkDetailsControllerFactory,
         settingsCoordinatorFactory: SettingsCoordinatorFactory) {
        mainViewControllers = MainViewControllers(bookmarkListCoordinator: bookmarkListCoordinatorFactory.makeBookmarkListCoordinator(),
                                                  addStubController: bookmarkDetailsControllerFactory.makeStubAddBookmarkController(),
                                                  settingsCoordinator: settingsCoordinatorFactory.makeSettingsCoordinator())

        super.init(nibName: nil, bundle: nil)

        configure()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
        delegate = self

        let bookmarkListViewController = startBookmarkListCoordinator()
        let stubController = mainViewControllers.addStubController
        let settingsController = mainViewControllers.settingsCoordinator.start()

        bookmarkListViewController.tabBarItem = UITabBarItem(title: "Bookmarks", image: Icon.bookmarkTabBar.image, selectedImage: nil)
        stubController.tabBarItem = UITabBarItem(title: "Add", image: Icon.addBookmarkTabBar.image, selectedImage: nil)
        settingsController.tabBarItem = UITabBarItem(title: "Settings", image: Icon.settingsTabBar.image, selectedImage: nil)

        viewControllers = [bookmarkListViewController, stubController, settingsController]
    }

    private func startBookmarkListCoordinator() -> UIViewController {
        mainViewControllers.bookmarkListCoordinator.output = { [unowned self] output in
            switch output {
            case .tappedGoToSettings:
                self.output?(.tappedGoToSettings)
            }
        }

        return mainViewControllers.bookmarkListCoordinator.start()
    }
}

extension MainTabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        if viewController == mainViewControllers.addStubController {
            output?(.addBookmark)
            return false
        } else {
            return true
        }
    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {

    }
}
