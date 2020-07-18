//
//  EventWebService.swift
//  SWFBO
//
//  Created by Julien Guillan on 15/07/2020.
//  Copyright © 2020 Julien Guillan. All rights reserved.
//

import Foundation

class EventWebService: WebService {
        
    func getAllEvents(user: User, completion: @escaping([Event]) -> Void) -> Void {
        guard let eventsURL = URL(string: self.endpoint + "bo/events") else {
            return
        }
        var request: URLRequest = URLRequest(url: eventsURL)
        request.addValue(user.token, forHTTPHeaderField: "Authorization")
        let task = URLSession.shared.dataTask(with: request, completionHandler: { (data: Data?, res, err) in
            guard let bytes = data,
                err == nil else {
                    return
            }
            guard let json = try? JSONSerialization.jsonObject(with: bytes, options: .allowFragments) as? [[String: Any]] else {
                completion([])
                return
            }
            let events = json.compactMap { (obj) -> Event? in
                guard let dict = obj as? [String: Any] else {
                    return nil
                }
                var event: Event!
                let eventId: Int = dict["id"] as! Int
                let experience = dict["experience"] as! Int
                let descrs = dict["descriptions"] as! [Any]
                var descriptions: [Description] = [Description]()
                let date_start: String = dict["date_start"] as! String
                let date_end: String = dict["date_end"] as! String
                let addresses = dict["address"] as! [Any]
                for descr in descrs{
                    print(descr)
                    guard let dico = descr as? [String: Any] else {
                        return nil
                    }
                    descriptions.append(DescriptionFactory.descriptionFrom(dictionnary: dico))
                }
                var eventAddress: Address!
                for address in addresses {
                    let addr = address as! [String: Any]
                    let addrId = addr["id"] as! Int
                    let country = addr["country"] as! String
                    let city = addr["city"] as! String
                    let street = addr["street"] as! String
                    let zipCode = addr["zip_code"] as! Int
                    let nbHouse = addr["nb_house"] as! Int
                    let complement = addr["complement"] as! String
                    eventAddress = Address(id: addrId, country: country, city: city, street: street, zipCode: zipCode, nbHouse: nbHouse, complement: complement)
                }
                event = Event(id: eventId, date_start: date_start, date_end: date_end, experience: experience, descriptions: descriptions, address: eventAddress)
                return event
            }
            completion(events)
        })
        task.resume()
    }
    
    func updateEvent(user: User, event: Event, completion: @escaping(Int) -> Void ) -> Void {
        guard let eventURL = URL(string: self.endpoint + "event") else {
            return
        }
        var resultCode = 0
        var request: URLRequest = URLRequest(url: eventURL)
        request.addValue(user.token, forHTTPHeaderField: "Authorization")
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonData = try? jsonEncoder.encode(event)
        request.httpBody = jsonData
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "content-type")
        let task = URLSession.shared.dataTask(with: request, completionHandler: {(data: Data?, res, err) in
            print("HERE")
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
    
    func createEvent(user: User, event: Event, completion: @escaping(Int) -> Void) -> Void {
        guard let eventURL = URL(string: self.endpoint + "bo/advice") else {
            return
        }
        var resultCode = 0
        var request: URLRequest = URLRequest(url: eventURL)
        request.addValue(user.token, forHTTPHeaderField: "Authorization")
        let jsonEncoder = JSONEncoder()
        jsonEncoder.keyEncodingStrategy = .convertToSnakeCase
        let jsonData = try? jsonEncoder.encode(event)
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
    
    func deleteEvent(user: User, event: Event, completion: @escaping(Int) -> Void ) -> Void {
        guard let eventURL = URL(string: self.endpoint + "event") else {
            return
        }
        var resultCode = 0
        var request: URLRequest = URLRequest(url: eventURL)
        request.addValue(user.token, forHTTPHeaderField: "Authorization")
        let jsonEncoder = JSONEncoder()
        let jsonData = try? jsonEncoder.encode(["id": event.id])
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
