//
//  ChallengeFactory.swift
//  SWFBO
//
//  Created by Julien Guillan on 02/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class ChallengeFactory {
    
    static func challengeFrom(dictionnary: [String: Any]) -> Challenge? {
        guard let id = dictionnary["foreign_id"] as? Int,
            let countryCode = dictionnary["country_code"] as? String,
            let title = dictionnary["title"] as? String,
            let name = dictionnary["name"] as? String,
            let description = dictionnary["description"] as? String else {
                return nil
        }
        return Challenge(id: id, countryCode: countryCode, title: title, name: name, descr: description)
    }
}
