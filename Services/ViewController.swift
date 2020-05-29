//
//  ViewController.swift
//  SWFBO
//
//  Created by Julien Guillan on 27/05/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import UIKit

class testViewController: UIViewController {
    let uws: UserWebService = UserWebService()
    override func viewDidLoad() {
        super.viewDidLoad()
        print("HERE1")
        uws.login(user: User(email: "blackack91@gmail.com", password: "password")) { (result) in
            print(result)
        }
        // Do any additional setup after loading the view.
    }
    
    func testUser(){
        let user: User = User(firstname: "UserIpad", lastname: "UserIpad", email: "testIpad@ipad.com", password: "password", birthday: Date(), isAdmin: true)
        uws.register(user: user, completion: { result in
            print(result)
        })
    }
}
