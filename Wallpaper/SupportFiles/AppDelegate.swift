//
//  AppDelegate.swift
//  Wallpaper
//
//  Created by yishen on 2020/10/14.
//  Copyright © 2020 BusinessTrip. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        self.window = UIWindow.init()
        let viewVC = PPHomeController.init()
        let navigation = UINavigationController.init(rootViewController: viewVC)
        self.window?.rootViewController = navigation
        self.window?.makeKeyAndVisible()
        return true
    }

}

