//
//  AppDelegate.swift
//  WorldTime
//
//  Created by Max von Webel on 21/09/14.
//  Copyright (c) 2014 Max von Webel. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        let window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window = window

        window.rootViewController = UINavigationController(rootViewController: LocationsEditorViewController())
        window.makeKeyAndVisible()

        return true
    }
}

