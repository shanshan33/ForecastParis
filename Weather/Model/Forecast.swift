//
//  Forecast.swift
//  Weather
//
//  Created by Shanshan Zhao on 20/11/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import Foundation

public struct Forecast {
    let city: City?
    let cnt: Int?
    let cod: String?
    let list: [List]?
    let message: Double?

}

extension Forecast {
    public init(list: [List]? = nil, city: City, cnt:Int, cod: String, message: Double) {
        self.city = city
        self.list = list
        self.cnt = cnt
        self.message = message
        self.cod = cod
    }
}

extension Forecast: JSONInitializable {
    
    public enum Key: String {
        case city = "city"
        case list = "list"
        case cnt = "cnt"
        case cod = "cod"
        case message = "message"
    }
    
    public init(with json: JSON) throws {

        self.cnt  = Forecast.optionalValue(for: .cnt, in: json)
        self.cod  = Forecast.optionalValue(for: .cod, in: json)
        self.message = Forecast.optionalValue(for: .message, in: json)
        self.city = try Forecast.optionalValue(for: .city, in: json).flatMap(City.init(with: ))
        
        var lists: [List] = []
        for case let result in (json["list"] as? [JSON])! {
            let list = try List.init(with: result)
            lists.append(list)
        }
        self.list = lists
    }
}
