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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        let w = UIWindow(frame: UIScreen.main.bounds)
        let db:DBHelper = DBHelper()
        let user = db.selectWhereId(id: 0)
        challengeWebService.getChallengebyId(token: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MiwiaWF0IjoxNTkxMTMxMzIzLCJleHAiOjE1OTEyMTc3MjN9.A-SvSrH87e0kv0DDp6iwbwbkHWdQ3bAu6rluHS45tIQ", id: 2, completion: { (challenge) in
            print(challenge)
        })
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

