//
//  ControllerFactory.swift
//  Airpin
//
//  Created by Thomas Carey on 5/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import UIKit

class RootControllerFactory {
    func makeRootController(bookmarkListCoordinatorFactory: BookmarkListCoordinatorFactory,
                            bookmarkDetailsControllerFactory: BookmarkDetailsControllerFactory,
                            settingsCoordinatorFactory: SettingsCoordinatorFactory) -> MainTabBarController {
        return MainTabBarController(bookmarkListCoordinatorFactory: bookmarkListCoordinatorFactory,
                                    bookmarkDetailsControllerFactory: bookmarkDetailsControllerFactory,
                                    settingsCoordinatorFactory: settingsCoordinatorFactory)
    }
}
