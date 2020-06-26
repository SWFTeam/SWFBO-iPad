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
    
    let challengeWebService: ChallengeWebService = ChallengeWebService()
    
    func applicationDidBecomeActive(_ application: UIApplication) {
         //This method is called when the rootViewController is set and the view.
        
    }

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
       /* let w = UIWindow(frame: UIScreen.main.bounds)
        let db:DBHelper = DBHelper()
        let user = db.selectWhereId(id: 0)
        /*challengeWebService.getAllChallenges(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNTkxMjA5NzQ0LCJleHAiOjE1OTEyOTYxNDR9.l8SGx8sonTnpHa0NC660Ilr3cJd_ciT2dMAzjfN_GaA", completion: { (challenges) in
            print(challenges)
        })*/
        if(user.email != "nil"){
            w.rootViewController =  UINavigationController(rootViewController: MenuViewController())
        } else {
            w.rootViewController =  UINavigationController(rootViewController: LoginViewController())
        }
        w.makeKeyAndVisible()
        self.window = w
        return true*/
        
        let db:DBHelper = DBHelper()
        let user = db.selectWhereId(id: 0)

        let viewController = SplitViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }


}

