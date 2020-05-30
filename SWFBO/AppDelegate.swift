//
//  AppDelegate.swift
//  SWFBO
//
//  Created by Julien Guillan on 25/05/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let w = UIWindow(frame: UIScreen.main.bounds)
        let db:DBHelper = DBHelper()
        let user = db.selectWhereId(id: 0)
        print(user)
        if(user.email != "nil"){
            w.rootViewController =  UINavigationController(rootViewController: HomeViewController())
        } else {
            w.rootViewController =  UINavigationController(rootViewController: LoginViewController())
        }
        w.makeKeyAndVisible()
        self.window = w
        return true
    }


}

