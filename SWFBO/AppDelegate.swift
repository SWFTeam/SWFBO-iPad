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
    var userWebService: UserWebService!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let w = UIWindow(frame: UIScreen.main.bounds)
        let db: DBHelper = DBHelper()
        let user = db.selectWhereId(id: 1)
        if(user.email != "nil"){
            self.userWebService.login(user: user) { (userLogged) in
                user.setToken(token: userLogged.token)
                db.insert(id: 1, firstname: user.firstname!, lastname: user.lastname!, email: user.email, token: userLogged.token)
                w.rootViewController =  UINavigationController(rootViewController: HomeViewController())
            }
        } else {
            w.rootViewController =  UINavigationController(rootViewController: LoginViewController())
        }
        w.makeKeyAndVisible()
        self.window = w
        return true
    }
}

