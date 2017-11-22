//
//  NetworkManagerProtocol.swift
//  Weather
//
//  Created by Shanshan Zhao on 20/11/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//
import Foundation

/**
 *  A 'ForecastAPI' do request use URLSession,
 *  it gives 'Forecast' as result if success
 */

public enum Result<Value> {
    case success(Value)
    case failure(Error?)
}

enum JSONError: Error {
    case NoData
    case ConversionFailed
}

class ForecastAPI {
    func fetchForecast(_ urlString: String, withCompletion completion: ((Result<Forecast>) -> Void)?) {
        guard let requestUrl = URL(string:urlString) else { return }
        let request = URLRequest(url:requestUrl)
        URLSession.shared.dataTask(with: request) { (data, response, error) in
            do {
                guard let data = data else {
                    throw JSONError.NoData
                }
                if let json = try JSONSerialization.jsonObject(with: data, options: []) as? JSON {
                    guard let results = try? Forecast.init(with: json) else {
                        throw JSONError.ConversionFailed
                    }
                    completion!(.success(results))
                } else {
                    throw JSONError.ConversionFailed
                }
            } catch let error as NSError {
                print(error.debugDescription)
            }
            }.resume()
    }
        
}

