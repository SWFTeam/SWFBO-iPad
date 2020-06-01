//
//  UserFactory.swift
//  SWFBO
//
//  Created by Julien Guillan on 27/05/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class UserFactory {
    static func userFrom(dictionnary: [String: Any]) -> User? {
        let id: Int? = dictionnary["id"] as? Int
        print(dictionnary)
        guard let firstname = dictionnary["firstname"] as? String,
            let lastname = dictionnary["lastname"] as? String,
            let email = dictionnary["email_address"] as? String,
            let password = dictionnary["password"] as? String,
            let birthday = dictionnary["birthday"] as? String,
            let last_login_at = dictionnary["last_login_at"] as? String,
            let created_at = dictionnary["created_at"] as? String else {
                return nil
        }
        print(firstname, lastname, email, password, birthday)
        
        if(id != nil){
            let user = User(id: id!, firstname: firstname, lastname: lastname, email: email, password: password, birthday: birthday, last_login_at: last_login_at, created_at: created_at, isAdmin: true)
            print(user)
            return user
        } else {
            return User(id: id!, firstname: firstname, lastname: lastname, email: email, password: password, birthday: birthday, last_login_at: last_login_at, created_at: created_at, isAdmin: true)
        }
        
    }
}
