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
}
