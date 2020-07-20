//
//  SplitViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 25/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class SplitViewController : UISplitViewController, UISplitViewControllerDelegate {
    
    var user: User!
    let master = UINavigationController()
    let detail = UINavigationController()
        
    override func viewDidLoad() {
        
        self.delegate = self
        //self.master.viewControllers = [MenuViewController()]
        //self.detail.viewControllers = [HomeViewController.newInstance(user: self.user)]
        self.viewControllers = [master, detail]
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let uws = UserWebService()
        let alert = UIAlertController(title: "Login", message: "Please login to access", preferredStyle: .alert)
        alert.addTextField { (textField) in
            textField.placeholder = "Email address"
            textField.text = "blackack91@gmail.com"
        }
        alert.addTextField { (textField) in
            textField.placeholder = "password"
            textField.text = "password"
            textField.isSecureTextEntry = true
        }
        alert.addAction(UIAlertAction(title: "Login", style: .default, handler: { [weak alert] (_) in
            let email = alert?.textFields![0].text
            let password = alert?.textFields![1].text
            if(email == "" || password == ""){
                let alertLogin = UIAlertController(title: "login failed !", message: "Bad username/password \n RESTRICTED AREA - STAFF ONLY", preferredStyle: .alert)
                alertLogin.addAction(UIAlertAction(title: "Close", style: .destructive, handler: { (action) in
                    UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
                    exit(0)
                }))
                DispatchQueue.main.async {
                    self.present(alertLogin, animated: true)
                }
            } else {
                let user = User(email: email!, password: password!)
                uws.login(user: user) { (userRes) in
                    if(userRes.token != "nil"){
                        let db:DBHelper = DBHelper()
                        uws.getAdditionnalData(user: user) { (userComplete) in
                            if(userComplete.isAdmin){
                                db.insert(id: 0, firstname: userComplete.firstname!, lastname: userComplete.lastname!, email: user.email, token: user.token)
                                user.firstname = userComplete.firstname
                                user.lastname = userComplete.lastname
                                self.user = user
                                DispatchQueue.main.async {
                                    self.master.viewControllers = [MenuViewController.newInstance(user: self.user)]
                                    self.detail.viewControllers = [HomeViewController.newInstance(user: self.user)]
                                }
                            } else {
                                let alertLogin = UIAlertController(title: "UNAUTHORIZED !", message: "RESTRICTED AREA - STAFF ONLY", preferredStyle: .alert)
                                alertLogin.addAction(UIAlertAction(title: "Close", style: .destructive, handler: { (action) in
                                    UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
                                }))
                                DispatchQueue.main.async {
                                    self.present(alertLogin, animated: true)
                                }
                            }
                        }
                    } else {
                        let alertLogin = UIAlertController(title: "login failed !", message: "Bad username/password \n RESTRICTED AREA - STAFF ONLY", preferredStyle: .alert)
                        alertLogin.addAction(UIAlertAction(title: "Close", style: .destructive, handler: { (action) in
                            UIControl().sendAction(#selector(NSXPCConnection.suspend), to: UIApplication.shared, for: nil)
                            exit(0)
                        }))
                        DispatchQueue.main.async {
                            self.present(alertLogin, animated: true)
                        }
                    }
                }
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
}
