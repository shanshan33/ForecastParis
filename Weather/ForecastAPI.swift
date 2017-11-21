//
//  NetworkManagerProtocol.swift
//  Weather
//
//  Created by Shanshan Zhao on 19/11/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//
import Foundation

class NetworkManager {
    func fetchForecast(_ urlString: String, withCompletion completion: @escaping (Forecast) -> Void) {
        let url = URL(string: urlString)!
        let task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
     //       guard let data = data else {

     //           completion(nil)
                return
            }
            guard (try? JSONSerialization.jsonObject(with: data, options: .mutableContainers)) != nil else {
    //            completion(nil)
                return
            }
//            let result = Forecast(city: City() list: <#T##[List]#>)
//            completion(result)
        })
        task.resume()
    }
}

