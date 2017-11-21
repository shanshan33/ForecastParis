//
//  list.swift
//  Weather
//
//  Created by Shanshan Zhao on 20/11/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import Foundation

public struct List {
    let time: String
    let temp: Main?
    let weather: [Weather]?
}

extension List {
    public init(temp: Main, time: String, weather: [Weather]? = nil) {
        self.time    = time
        self.temp    = temp
        self.weather = weather
    }
}

extension List: JSONInitializable {
    
    public enum Key: String {
        case Time    = "dt_txt"
        case Temp    = "main"
        case Weather = "weather"
    }
    
    public init(with json: JSON) throws {
        self.time = try List.value(for: .Time, in: json)
        self.temp   = try List.optionalValue(for: .Temp, in: json).flatMap(Main.init(with:))

        var weathers: [Weather] = []
        for case let result in (json["weather"] as? [JSON])! {
            let weather = try Weather.init(with: result)
            weathers.append(weather)
        }
        self.weather = weathers
    }
}
