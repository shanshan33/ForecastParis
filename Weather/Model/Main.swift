//
//  Temp.swift
//  Weather
//
//  Created by Shanshan Zhao on 20/11/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import Foundation

public struct Main {
    let humidity: Double
    let pressure: Double
    let averageTemp: Double
    let temp_max: Double
    let temp_min: Double
}

extension Main {
    public init( pressure: Double, humidity: Double, averageTemp: Double, temp_max: Double, temp_min: Double) {
        self.humidity = humidity
        self.pressure   =  pressure
        self.averageTemp =  averageTemp
        self.temp_max = temp_max
        self.temp_min = temp_min
    }
}

extension Main: JSONInitializable {
    
    public enum Key: String {
        case humidity     = "humidity"
        case pressure     = "pressure"
        case averageTemp  = "temp"
        case temp_max     = "temp_max"
        case temp_min     = "temp_min"
    }
    
    public init(with json: JSON) throws {
        self.humidity = try Main.value(for: .humidity, in: json)
        self.pressure   = try Main.value(for: .pressure, in: json)
        self.averageTemp = try Main.value(for: .averageTemp, in: json)
        self.temp_max = try Main.value(for: .temp_max, in: json)
        self.temp_min = try Main.value(for: .temp_min, in: json)
    }
}
