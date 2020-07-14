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
        
        let viewController = SplitViewController()
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.rootViewController = viewController
        window.makeKeyAndVisible()
        self.window = window
        
        return true
    }


}

