//
//  City.swift
//  Weather
//
//  Created by Shanshan Zhao on 19/11/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import Foundation

public struct City {
    let coordinate: Coordinate?
    let country: String
    let id: Int
    let name: String
}

extension City {
    public init(coordinate: Coordinate, id: Int, country: String, name: String) {
        self.coordinate = coordinate
        self.country   =  country
        self.id =  id
        self.name = name
    }
}

extension City: JSONInitializable {
    
    public enum Key: String {
        case Coordinate = "coord"
        case Country    = "country"
        case ID         = "id"
        case Name       = "name"
    }
    
    public init(with json: JSON) throws {
        self.coordinate = try City.optionalValue(for: .Coordinate, in: json).flatMap(Coordinate.init(with: ))
        self.country   = try City.value(for: .Country, in: json)
        self.id = try City.value(for: .ID, in: json) ?? 0
        self.name = try City.value(for: .Name, in: json)
    }
}
