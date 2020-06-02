//
//  ChallengeWebService.swift
//  SWFBO
//
//  Created by Julien Guillan on 02/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class ChallengeWebService {
    let endpoint: String = "http://localhost:3000/"
    func getChallengebyId(token: String, id: Int, completion: @escaping(Challenge) -> Void) -> Void {
        guard let challengeURL = URL(string: self.endpoint + "challenge") else {
            return;
        }
        var challenge: Challenge!
        var request: URLRequest = URLRequest(url: challengeURL)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        let json: [String: Any] = [ "id": id ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request){ data, response, error in
            if((error) != nil){
                print("error \(error)")
                return
            }
            if let httpRes = response as? HTTPURLResponse {
                if httpRes.statusCode == 200 {                    let result = try? JSONSerialization.jsonObject(with: data!, options: [])
                    if let dictionary = result as? [String: [String: Any]] {
                        let descriptions = dictionary["challenge"]!["descriptions"]!
                        let descrs = descriptions as! Array<Any>
                        for descr in descrs {
                            let description = descr as! [String: Any]
                            if(description["country_code"] as! String == Locale.current.regionCode!){
                                challenge = Challenge(id: description["foreign_id"] as! Int, countryCode: description["country_code"] as! String, title: description["title"] as! String, name: description["name"] as! String, descr: description["description"] as! String)
                            } else {
                                challenge = Challenge(id: description["foreign_id"] as! Int, countryCode: description["country_code"] as! String, title: description["title"] as! String, name: description["name"] as! String, descr: description["description"] as! String)
                            }
                        }
                    }
                }
            }
            completion(challenge)
        }
        task.resume()
    }
}
