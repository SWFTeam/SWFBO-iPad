//
//  APIWebService.swift
//  SWFBO
//
//  Created by Henri Gourgue on 03/06/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class APIWebService: WebService {
    
    struct Status:Codable {
        var mysql_status: String?
        var api_state: String?
    }
    
    var status: Status!
    
    func getStatus(completion: @escaping(Status) -> Void) -> Void {
        
        // Create URL
        let url = URL(string: self.endpoint + "status")
        guard let requestUrl = url else { fatalError() }

        // Create URL Request
        var request = URLRequest(url: requestUrl)

        // Specify HTTP Method to use
        request.httpMethod = "GET"

        // Send HTTP Request
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            
            // Check if Error took place
            if let error = error {
                print("Error took place \(error)")
                return
            }
            
            // Read HTTP Response Status code
            if let response = response as? HTTPURLResponse {
                print("Response HTTP Status code: \(response.statusCode)")
            }
            
            if let json = try? JSONDecoder().decode(Status.self, from: data!){

                self.status = json
                DispatchQueue.main.sync {
                    completion(self.status)
                }
            }
            
        }
        task.resume()
    }
}
