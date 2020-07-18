//
//  Challenge.swift
//  SWFBO
//
//  Created by Julien Guillan on 02/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class Challenge: Codable, CustomStringConvertible {
    
    var id: Int
    var descriptions: [Description]
    var experience: Int
    
    init(id: Int, experience: Int, descriptions: [Description]) {
        self.id = id
        self.descriptions = descriptions
        self.experience = experience
    }
    
    var description: String {
        return ("\(self.id) - \(self.descriptions)")
    }
}
