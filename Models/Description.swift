//
//  Description.swift
//  SWFBO
//
//  Created by Julien Guillan on 04/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class Description: Codable, CustomStringConvertible {
    
    var id: Int
    var countryCode: String
    var title: String
    var name: String
    var descr: String
    
    init(id: Int, countryCode: String, title: String, name: String, descr: String) {
        self.id = id
        self.countryCode = countryCode
        self.title = title
        self.name = name
        self.descr = descr
    }
    
    var description: String {
        return "\(self.id) - \(self.countryCode) - \(self.title) - \(self.name) - \(self.descr)"
    }
}
