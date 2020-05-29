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
        var user: User = User(id: 0, firstname: "Julien", lastname: "Guillan", email: "blackack91@gmail.com", token: "nil")
        uws.login(user: User(email: user.email, password: "password")) { (result) in
            if(result.getToken() == "nil"){
                print("ERROR CREDENTIALS")
            } else {
                user.setToken(token: result.getToken())
                print("WELCOME BACK")
                let db:DBHelper = DBHelper()
                print("TEST INSERT DB")
                db.insert(id: 0, firstname: user.firstname!, lastname: user.lastname!, email: user.email, token: user.token)
                print("TEST SELECT DB")
                let result = db.selectWhereId(id: 1)
                print(result)
            }
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
