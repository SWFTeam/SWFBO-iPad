//
//  User.swift
//  SWFBO
//
//  Created by Julien Guillan on 27/05/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class User: Codable{
    var id: Int?
    var firstname: String
    var lastname: String
    var email: String
    var password: String
    var birthday: Date
    /*var address: Address
    var addressWork: Address
    var survey: Survey*/
    var isAdmin: Bool
    
    init(id: Int, firstname: String, lastname: String, email: String, password: String, birthday: Date, /*address: String, addressWork: String, survey: String, */isAdmin: Bool) {
        self.id = id
        self.lastname = lastname
        self.firstname = firstname
        self.email = email
        self.password = password
        self.birthday = birthday
        //self.address = address
        //self.addressWork = addressWork
        //self.survey = survey
        self.isAdmin = isAdmin
    }
    
    init(firstname: String, lastname: String, email: String, password: String, birthday: Date, /*address: String, addressWork: String, survey: String, */isAdmin: Bool) {
        self.lastname = lastname
        self.firstname = firstname
        self.email = email
        self.password = password
        self.birthday = birthday
        //self.address = address
        //self.addressWork = addressWork
        //self.survey = survey
        self.isAdmin = isAdmin
    }
    
    var description: String {
        return "{\(self.firstname) - \(self.lastname) }"
    }
}
