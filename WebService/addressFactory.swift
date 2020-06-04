//
//  addressFactory.swift
//  SWFBO
//
//  Created by Julien Guillan on 28/05/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class AddressFactory {
    static func userFrom(dictionnary: [String: Any]) -> Address? {
        let id: Int? = dictionnary["id"] as? Int
        
        guard let country = dictionnary["country"] as? String,
            let city = dictionnary["city"] as? String,
            let street = dictionnary["street"] as? String,
            let zipCode = dictionnary["zipCode"] as? Int,
            let nbHouse = dictionnary["nbHouse"] as? Int,
            let complement = dictionnary["complement"] as? String,
            let created_at = dictionnary["created_at"] as? String else {
                return nil
        }
        
        if(id != nil){
            return Address(id: id!, country: country, city: city, street: street, zipCode: zipCode, nbHouse: nbHouse, complement: complement, created_at: created_at)
        } else {
            return Address(id: id!, country: country, city: city, street: street, zipCode: zipCode, nbHouse: nbHouse, complement: complement, created_at: created_at)
        }
        
    }
}
