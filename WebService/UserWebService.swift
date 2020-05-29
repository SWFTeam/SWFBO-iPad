//
//  UserWebService.swift
//  SWFBO
//
//  Created by Julien Guillan on 27/05/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class UserWebService {
    let token: String = "nil"
    
    func register(user: User, completion: @escaping (Bool) -> Void) -> Void {
        guard let signinURL = URL(string: "http://localhost:3000/bo/signin")
                else{
                    return;
                }
            var request = URLRequest(url: signinURL)
            guard let dataToUpload = try? JSONEncoder().encode(user) else{return;}
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "content-type")
            let task = URLSession.shared.uploadTask(with: request, from: dataToUpload){data, response, error in
                print(data)
                if let error = error {
                    print ("error: \(error)")
                    return
                }
                if let httpRes = response as? HTTPURLResponse {
                    completion(httpRes.statusCode == 201)
                    print(user.description)
                    return
                }
                print(response)
                completion(false)

            }
        task.resume()
    }
    
    func getAllUsers(completion: @escaping ([User]) -> Void) -> Void {
        guard let usersURL = URL(string: "http://localhost:3000/bo/users") else {
            return;
        }
        let task = URLSession.shared.dataTask(with: usersURL, completionHandler: { (data: Data?, res, err) in
            guard let bytes = data,
                  err == nil,
                  let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [Any] else {
                    DispatchQueue.main.sync {
                        completion([])
                    }
                return
            }
            print(json)
            let users = json.compactMap { (obj) -> User? in
                guard let dict = obj as? [String: Any] else {
                    return nil
                }
                return UserFactory.userFrom(dictionnary: dict)
            }
            print(users)
            DispatchQueue.main.sync {
                completion(users)
            }
        })
        task.resume()
    }
    
    func login(user: User, completion: @escaping(User) -> Void) -> Void {
        guard let loginUrl = URL(string: "http://localhost:3000/bo/signin") else {
            return;
        }
        var request = URLRequest(url: loginUrl)
        guard let dataToUpload = try? JSONEncoder().encode(user) else {return}
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.uploadTask(with: request, from: dataToUpload){data, response, error in
            if let error = error {
                print ("error: \(error)")
                return
            }
            if let httpRes = response as? HTTPURLResponse {
                if httpRes.statusCode == 200 {
                    let result = try? JSONSerialization.jsonObject(with: data!, options: [])
                    if let dictionary = result as? [String: Any] {
                    if let token = dictionary["token"] as? String {
                            user.setToken(token: token)
                        }
                    }
                }
            }
            completion(user)

        }
        task.resume()
    }
}
