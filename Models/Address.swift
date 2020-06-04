//
//  Address.swift
//  SWFBO
//
//  Created by Julien Guillan on 27/05/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class Address {
    var id: Int
    var country: String
    var city: String
    var street: String
    var zipCode: Int
    var nbHouse: Int
    var complement: String
    var createdAt: String
    
    init(id: Int, country: String, city: String, street: String, zipCode: Int, nbHouse: Int, complement: String, created_at: String){
        self.id = id
        self.country = country
        self.city = city
        self.street = street
        self.zipCode = zipCode
        self.nbHouse = nbHouse
        self.complement = complement
        self.createdAt = created_at
    }
}
