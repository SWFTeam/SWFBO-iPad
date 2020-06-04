//
//  DescriptionFactory.swift
//  SWFBO
//
//  Created by Julien Guillan on 04/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

class DescriptionFactory {
    
    static func descriptionFrom(dictionnary: [String: Any]) -> Description {
        
        let id = dictionnary["id"] as? Int
        let countryCode = dictionnary["country_code"] as? String
        let title = dictionnary["title"] as? String
        let name = dictionnary["name"] as? String
        let description = dictionnary["description"] as? String
        
        return Description(id: id!, countryCode: countryCode!, title: title!, name: name!, descr: description!)
    }
}
