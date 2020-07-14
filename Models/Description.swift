//
//  Description.swift
//  SWFBO
//
//  Created by Julien Guillan on 04/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class Description: Codable {
    
    var id: Int
    var countryCode: String
    var title: String
    var name: String
    var description: String
    var type: String
    
    init(id: Int, countryCode: String, title: String, name: String, descr: String, type: String) {
        self.id = id
        self.countryCode = countryCode
        self.title = title
        self.name = name
        self.description = descr
        self.type = type
    }
}
