//
//  JSONDownloader.swift
//  WeatherBB
//
//  Created by Mustafa Saeed on 8/12/17.
//  Copyright © 2017 Mustafa Saeed. All rights reserved.
//

import Foundation

class JSONDownloader {
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    typealias JSON = [String: AnyObject]
    typealias JSONTaskCompletionHandler = (JSON?, WeatherApiErrors?) -> Void
    
    func jsonTask(with request: URLRequest, completionHandler completion: @escaping JSONTaskCompletionHandler) -> URLSessionDataTask {
        let task = session.dataTask(with: request) { data, response, error in
            // what to do with the data, response and error:
            
            // Convert to HTTP Response
            guard let httpResponse = response as? HTTPURLResponse else {
                completion(nil, .requestFailed)
                return
            }
            
            // 200 => that everyhting is ok (with the response)
            if httpResponse.statusCode == 200 {
                if let data = data {
                    do {
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: AnyObject]
                        completion(json, nil)
                    } catch {
                        completion(nil, .jsonConversionFailure)
                    }
                    
                } else {
                    completion(nil, .invalidData)
                }
            } else {
                completion(nil, .responseUnsuccessful)
            }
        }
        return task
    }

}
