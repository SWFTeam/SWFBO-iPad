//
//  Advice.swift
//  SWFBO
//
//  Created by Julien Guillan on 17/07/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class Advice: Codable {
    
    var id: Int
    var descriptions: [Description]
    
    init(id: Int, descriptions: [Description]) {
        self.id = id
        self.descriptions = descriptions
    }
}
