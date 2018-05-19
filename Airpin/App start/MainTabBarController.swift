//
//  MainTabBarController.swift
//  Airpin
//
//  Created by Thomas Carey on 5/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import UIKit

struct MainViewControllers {
    let bookmarkListViewController: UIViewController
    let addStubController: UIViewController
    let settingsCoordinator: SettingsCoordinator
}

enum MainTabBarControllerPresentableOutput {
    case addBookmark
}

protocol MainTabBarControllerPresentable {
    var output: ((MainTabBarControllerPresentableOutput) -> Void)? { get set }
}

class MainTabBarController: UITabBarController {

    var output: ((MainTabBarControllerPresentableOutput) -> Void)?

    fileprivate let mainViewControllers: MainViewControllers

    init(bookmarkListControllerFactory: BookmarkListControllerFactory,
         bookmarkDetailsControllerFactory: BookmarkDetailsControllerFactory,
         settingsCoordinatorFactory: SettingsCoordinatorFactory) {
        mainViewControllers = MainViewControllers(bookmarkListViewController: bookmarkListControllerFactory.makePopularBookmarkListController(),
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

        let bookmarkListViewController = mainViewControllers.bookmarkListViewController
        let stubController = mainViewControllers.addStubController
        let settingsController = mainViewControllers.settingsCoordinator.start()

        bookmarkListViewController.tabBarItem = UITabBarItem(title: "Bookmarks", image: Icon.bookmarkTabBar.image, selectedImage: nil)
        stubController.tabBarItem = UITabBarItem(title: "Add", image: Icon.addBookmarkTabBar.image, selectedImage: nil)
        settingsController.tabBarItem = UITabBarItem(title: "Settings", image: Icon.settingsTabBar.image, selectedImage: nil)

        viewControllers = [UINavigationController(rootViewController: bookmarkListViewController), stubController, settingsController]
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
