//
//  LoginViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 29/05/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    var userWebService = UserWebService()
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func loginAction(_ sender: Any) {
        let email = self.emailTextField.text
        let password = self.passwordTextField.text

        if(email == "" || password == ""){

        } else {
            let user = User(email: email!, password: password!)
            self.userWebService.login(user: user) { (userRes) in
                if(userRes.token != "nil"){
                    let db:DBHelper = DBHelper()
                    self.userWebService.getAdditionnalData(user: user) { (userComplete) in
                        print(userComplete.isAdmin)
                        if(userComplete.isAdmin){
                            db.insert(id: 0, firstname: userComplete.firstname!, lastname: userComplete.lastname!, email: user.email, token: user.token)
                            user.firstname = userComplete.firstname
                            user.lastname = userComplete.lastname
                            DispatchQueue.main.async {
                                let homePage = MenuViewController.newInstance(user: user)
                                self.navigationController?.pushViewController(homePage, animated: true)
                            }
                        } else {
                            print("RESTRICTED ACCESS, NOT ALLOWED")
                        }
                    }
                } else {
                    
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
