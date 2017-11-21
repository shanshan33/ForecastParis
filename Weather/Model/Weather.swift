//
//  Weather.swift
//  Weather
//
//  Created by Shanshan Zhao on 20/11/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import Foundation

public struct Weather {
    let description: String
    let icon: String
    let id: Int
    let main: String
}

extension Weather {
    public init(icon: String, description: String, id: Int, main: String) {
        self.description = description
        self.icon   =  icon
        self.id =  id
        self.main = main
    }
}

extension Weather: JSONInitializable {
    
    public enum Key: String {
        case description = "description"
        case icon        = "icon"
        case id          = "id"
        case main        = "main"
    }
    
    public init(with json: JSON) throws {
        self.description = try Weather.value(for: .description, in: json)
        self.icon   = try Weather.value(for: .icon, in: json)
        self.id = try Weather.value(for: .id, in: json) ?? 0
        self.main = try Weather.value(for: .main, in: json)
    }
}

