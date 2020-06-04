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
    
    init(id: Int, descriptions: [Description]) {
        self.id = id
        self.descriptions = descriptions
    }
    
    var description: String {
        return ("\(self.id) - \(self.descriptions)")
    }
}
