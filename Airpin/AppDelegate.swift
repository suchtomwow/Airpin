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
  
  func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {

    window?.tintColor = UIColor.primaryColor()
    
    Fabric.with([Crashlytics.self])
    return true
  }

  func applicationWillResignActive(_ application: UIApplication) {
  
  }

  func applicationDidEnterBackground(_ application: UIApplication) {
  
  }

  func applicationWillEnterForeground(_ application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(_ application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(_ application: UIApplication) {

  }
  
  func completeUserInterface() {
    
  }
}
