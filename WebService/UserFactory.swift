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
        
        guard let firstname = dictionnary["firstname"] as? String,
            let lastname = dictionnary["lastname"] as? String,
            let email = dictionnary["email_address"] as? String,
            let password = dictionnary["password"] as? String,
            let birthday = dictionnary["birthday"] as? Date else {
                return nil
        }
        
        if(id != nil){
            return User(id: id!, firstname: firstname, lastname: lastname, email: email, password: password, birthday: birthday, isAdmin: true)
        } else {
            return User(id: id!, firstname: firstname, lastname: lastname, email: email, password: password, birthday: birthday, isAdmin: true)
        }
        
    }
}
