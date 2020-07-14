//
//  User.swift
//  SWFBO
//
//  Created by Julien Guillan on 27/05/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class User: Codable, CustomStringConvertible{
    var id: Int?
    var firstname: String?
    var lastname: String?
    var email: String
    var password: String?
    var birthday: String?
    var last_login_at: String!
    var created_at: String!
    /*var address: Address
    var addressWork: Address
    var survey: Survey*/
    var isAdmin: Bool = false
    var token: String = "nil"
    
    init(id: Int) {
        self.id = id
        self.email = "nil"
    }
    
    init(id: Int, firstname: String, lastname: String, email: String, password: String, birthday: String, last_login_at: String, created_at: String, /*address: String, addressWork: String, survey: String, */isAdmin: Bool) {
        self.id = id
        self.lastname = lastname
        self.firstname = firstname
        self.email = email
        self.password = password
        self.birthday = birthday
        self.last_login_at = last_login_at
        self.created_at = created_at
        //self.address = address
        //self.addressWork = addressWork
        //self.survey = survey
        self.isAdmin = isAdmin
    }
    
    init(firstname: String, lastname: String, email: String, password: String, birthday: String, last_login_at: String, created_at: String, /*address: String, addressWork: String, survey: String, */isAdmin: Bool) {
        self.lastname = lastname
        self.firstname = firstname
        self.email = email
        self.password = password
        self.birthday = birthday
        self.last_login_at = last_login_at
        self.created_at = created_at
        //self.address = address
        //self.addressWork = addressWork
        //self.survey = survey
        self.isAdmin = isAdmin
    }
    
    init(id: Int, firstname: String, lastname: String, email: String, token: String){
        self.firstname = firstname
        self.lastname = lastname
        self.email = email
        self.token = token
    }
    
    init(email: String, password: String){
        self.email = email
        self.password = password
    }
    
    func setToken(token: String) -> Void {
        self.token = token
    }

    func getToken() -> String {
        return self.token
    }
    
    var description: String {
        return "{\(self.firstname ?? "nil") - \(self.lastname ?? "nil") - \(self.email) - \(self.password ?? "nil") - \(self.isAdmin) - \(self.token) }"
    }

}
