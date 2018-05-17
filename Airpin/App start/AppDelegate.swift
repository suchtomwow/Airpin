//
//  AppDelegate.swift
//  Airpin
//
//  Created by Thomas Carey on 4/7/15.
//  Copyright © 2015 Thomas Carey. All rights reserved.
//

import UIKit
import Fabric
import Crashlytics

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    var coordinator: MainTabBarCoordinator?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey : Any]? = nil) -> Bool {

        Fabric.with([Crashlytics.self])

        let window = UIWindow(frame: UIScreen.main.bounds)
        window.tintColor = .primary
        self.window = window

        coordinator = MainTabBarCoordinator(window: window,
                                                rootControllerFactory: RootControllerFactory(),
                                                bookmarkListControllerFactory: BookmarkListControllerFactory(),
                                                bookmarkDetailsControllerFactory: BookmarkDetailsControllerFactory(),
                                                settingsControllerFactory: SettingsControllerFactory(),
                                                presenterType: PresenterImplementation.self)

        coordinator?.start()

        return true
    }
}

extension DispatchQueue {
    static let realmQueue = DispatchQueue.init(label: "com.airpin.realm", qos: .default)
}
