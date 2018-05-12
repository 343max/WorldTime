// Copyright 2014-present Max von Webel. All Rights Reserved.

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    
    func applicationDidFinishLaunching(_ application: UIApplication) {
        let window = UIWindow(frame: UIScreen.main.bounds)
        self.window = window

        window.rootViewController = UINavigationController(rootViewController: LocationsListViewController())
        window.makeKeyAndVisible()
    }
}

