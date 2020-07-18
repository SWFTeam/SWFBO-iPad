//
//  ChallengeWebService.swift
//  SWFBO
//
//  Created by Julien Guillan on 02/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class ChallengeWebService: WebService {
        
    /*func getChallengebyId(token: String, id: Int, completion: @escaping(Challenge) -> Void) -> Void {
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
                if httpRes.statusCode == 200 {
                    let result = try? JSONSerialization.jsonObject(with: data!, options: [])
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
    }*/
    
    func getAllChallenges(token: String, completion: @escaping([Challenge]) -> Void ) -> Void {
        guard let challengesURL = URL(string: self.endpoint + "bo/challenges") else {
            return;
        }
        var request: URLRequest = URLRequest(url: challengesURL)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, res, err) in
            guard let bytes = data,
                err == nil,
                let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [[String: Any]] else {
                    completion([])
                    return
                }
            let challenges = json.compactMap{ (obj) -> Challenge? in
                guard let dict = obj as? [String: Any] else {
                    return nil
                }
                var challenge: Challenge!
                let experience = dict["experience"] as! Int
                let descrs = dict["description"] as! [Any]
                var descriptions: [Description] = [Description]()
                let challId: Int = (dict["id"] as? Int)!
                for object in descrs{
                    guard let dico = object as? [String: Any] else {
                        return nil
                    }
                    descriptions.append(DescriptionFactory.descriptionFrom(dictionnary: dico))
                }
                challenge = Challenge(id: challId, experience: experience, descriptions: descriptions)
                return challenge
            }
            completion(challenges)
        })
        task.resume()
    }
    
    func removeChallenge(token: String, id: Int, completion: @escaping(Bool) -> Void ) -> Void {
        guard let deleteURL = URL(string: self.endpoint + "/challenge") else {
            return
        }
        var request: URLRequest = URLRequest(url: deleteURL)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        let json: [String: Any] = [ "id": id ]
        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        request.httpBody = jsonData
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (_, res, err) in
            if err == nil {
                completion(true)
            } else {
                completion(false)
            }
        })
        task.resume()
    }
    
    func updateChallenge(token: String, challenge: Challenge, completion: @escaping(Int) -> Void ) -> Void {
        guard let challengeURL = URL(string: self.endpoint + "challenge") else {
            return;
        }
        var resultCode: Int = 0
        var request: URLRequest = URLRequest(url: challengeURL)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonData = try? jsonEncoder.encode(challenge)
        //print(String(data: jsonData!, encoding: .utf8)) //debugging purpose
        request.httpBody = jsonData
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, res, err) in
            if let error = err {
                print ("error: \(error)")
                return
            }
            if let httpRes = res as? HTTPURLResponse {
                resultCode = httpRes.statusCode
            }
            completion(resultCode)
        })
        task.resume()
    }
    
    func createChallenge(token: String, challenge: Challenge, completion: @escaping(Int) -> Void ) -> Void {
        guard let challengeURL = URL(string: self.endpoint + "bo/challenge") else {
            return;
        }
        var resultCode: Int = 0
        var request: URLRequest = URLRequest(url: challengeURL)
        request.addValue(token, forHTTPHeaderField: "Authorization")
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonData = try? jsonEncoder.encode(challenge)
        //print(String(data: jsonData!, encoding: .utf8)) //debugging purpose
        request.httpBody = jsonData
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, res, err) in
            if let error = err {
                print ("error: \(error)")
                return
            }
            if let httpRes = res as? HTTPURLResponse {
                resultCode = httpRes.statusCode
            }
            completion(resultCode)
        })
        task.resume()
    }
    
    func deleteChallenge(user: User, challenge: Challenge, completion: @escaping(Int) -> Void ) -> Void {
        guard let challengeURL = URL(string: self.endpoint + "challenge" ) else {
            return;
        }
        var resultCode = 0;
        var request: URLRequest = URLRequest(url: challengeURL)
        request.addValue(user.token, forHTTPHeaderField: "Authorization")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(["id": challenge.id])
        request.httpBody = jsonData
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, res, err) in
            if let error = err {
                print("error: \(error)")
                return
            }
            if let httpRes = res as? HTTPURLResponse {
                resultCode = httpRes.statusCode
            }
            completion(resultCode)
        })
        task.resume()
    }
}
