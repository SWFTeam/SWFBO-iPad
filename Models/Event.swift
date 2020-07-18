//
//  Event.swift
//  SWFBO
//
//  Created by Julien Guillan on 15/07/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class Event: Codable {
    var id: Int
    var date_start: String
    var date_end: String
    var experience: Int
    var descriptions: [Description]
    var address: Address
    
    init(id: Int, date_start: String, date_end: String, experience: Int, descriptions: [Description], address: Address) {
        self.id = id
        self.date_start = date_start
        self.date_end = date_end
        self.experience = experience
        self.descriptions = descriptions
        self.address = address
    }
}
