//
//  addressWebService.swift
//  SWFBO
//
//  Created by Julien Guillan on 28/05/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class AddressWebService: WebService {
            
    func getAddressById(user: User, id: Int, completion: @escaping(Address) -> Void ) -> Void {
        guard let addressURL = URL(string: self.endpoint + "addresses/" + String(id)) else {
            return
        }
        
        var request: URLRequest = URLRequest(url: addressURL)
        request.addValue(user.token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, res, err) in
            guard let bytes = data,
                err == nil else {
                    return
            }
            guard let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [String: Any] else {
                print("JSON PARSING FAILED")
                return
            }
            if let dictionnary = json as? [String: Any] {
                let addressId = dictionnary["id"] as! Int
                let country = dictionnary["country"] as! String
                let city = dictionnary["city"] as! String
                let street = dictionnary["street"] as! String
                let zipCode = dictionnary["zip_code"] as! Int
                let nbHouse = dictionnary["nb_house"] as! Int
                let complement = dictionnary["complement"] as! String
                let address = Address(id: addressId, country: country, city: city, street: street, zipCode: zipCode, nbHouse: nbHouse, complement: complement)
                completion(address)
            } else {
                return
            }
        })
        task.resume()
    }
    
}
