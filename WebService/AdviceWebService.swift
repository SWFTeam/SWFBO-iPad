//
//  AdviceWebService.swift
//  SWFBO
//
//  Created by Julien Guillan on 17/07/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class AdviceWebService: WebService {
    
    func getAllAdvices(user: User, completion: @escaping([Advice]) -> Void ) -> Void {
        guard let advicesURL = URL(string: endpoint + "bo/advices" ) else {
            return
        }
        var request: URLRequest = URLRequest(url: advicesURL)
        request.addValue(user.token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, res, err) in
            guard let bytes = data,
                err == nil,
                let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [[String: Any]] else {
                    completion([])
                    return
                }
            let advices = json.compactMap{ (obj) -> Advice? in
                guard let dict = obj as? [String: Any] else {
                    return nil
                }
                var advice: Advice!
                let descrs = dict["descriptions"] as! [Any]
                var descriptions: [Description] = [Description]()
                let adviceId: Int = (dict["id"] as? Int)!
                for object in descrs{
                    guard let dico = object as? [String: Any] else {
                        return nil
                    }
                    descriptions.append(DescriptionFactory.descriptionFrom(dictionnary: dico))
                }
                advice = Advice(id: adviceId, descriptions: descriptions)
                return advice
            }
            completion(advices)
        })
        task.resume()
    }
    
    func updateAdvice(user: User, advice: Advice, completion: @escaping(Int) -> Void ) -> Void {
        guard let updateURL = URL(string: self.endpoint + "bo/advice") else {
            return
        }
        var resultCode = 0
        var request: URLRequest = URLRequest(url: updateURL)
        request.addValue(user.token, forHTTPHeaderField: "Authorization")
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonData = try? jsonEncoder.encode(advice)
        request.httpBody = jsonData
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, res, err) in
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
    
    func createAdvice(user: User, advice: Advice, completion: @escaping(Int) -> Void) -> Void {
        guard let createURL = URL(string: self.endpoint + "bo/advice") else {
            return
        }
        var resultCode = 0
        var request: URLRequest = URLRequest(url: createURL)
        request.addValue(user.token, forHTTPHeaderField: "Authorization")
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonData = try? jsonEncoder.encode(advice)
        request.httpBody = jsonData
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, res, err) in
            if let error = err {
                print("error \(error)")
                return
            }
            if let httpRes = res as? HTTPURLResponse {
                resultCode = httpRes.statusCode
            }
            completion(resultCode)
        })
        task.resume()
    }
    
    func deleteAdvice(user: User, advice: Advice, completion: @escaping(Int) -> Void ) -> Void {
        guard let deleteURL = URL(string: self.endpoint + "advice") else {
            return
        }
        var resultCode = 0
        var request: URLRequest = URLRequest(url: deleteURL)
        request.addValue(user.token, forHTTPHeaderField: "Authorization")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(["id": advice.id])
        request.httpBody = jsonData
        request.httpMethod = "DELETE"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request, completionHandler:  { (data: Data?, res, err) in
            if let error = err {
                print("error \(error)")
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
