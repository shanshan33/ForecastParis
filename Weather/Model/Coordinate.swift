//
//  Coordinate.swift
//  Weather
//
//  Created by Shanshan Zhao on 19/11/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import Foundation

public struct Coordinate {
    let latitude: Double
    let longitude: Double
}

extension Coordinate {
    public init(longitude: Double, latitude: Double) {
        self.latitude  =  latitude
        self.longitude =  longitude
    }
}

extension Coordinate: JSONInitializable {
    
    public enum Key: String {
        case Latitude  = "lat"
        case Longitude = "lon"
    }
    
    public init(with json: JSON) throws {
        self.latitude = try Coordinate.value(for: .Latitude, in: json) ?? 0
        self.longitude = try Coordinate.value(for: .Longitude, in: json) ?? 0
    }
}
