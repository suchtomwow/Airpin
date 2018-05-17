//
//  ControllerFactory.swift
//  Airpin
//
//  Created by Thomas Carey on 5/4/18.
//  Copyright © 2018 Thomas Carey. All rights reserved.
//

import UIKit

class RootControllerFactory {
    func makeRootController(bookmarkListControllerFactory: BookmarkListControllerFactory,
                            bookmarkDetailsControllerFactory: BookmarkDetailsControllerFactory,
                            settingsControllerFactory: SettingsControllerFactory) -> MainTabBarController {
        return MainTabBarController(bookmarkListControllerFactory: bookmarkListControllerFactory,
                                    bookmarkDetailsControllerFactory: bookmarkDetailsControllerFactory,
                                    settingsControllerFactory: settingsControllerFactory)
    }
}
