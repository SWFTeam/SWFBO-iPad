//
//  UserWebService.swift
//  SWFBO
//
//  Created by Julien Guillan on 27/05/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class UserWebService {
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
}
