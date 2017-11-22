//
//  Weather.swift
//  Weather
//
//  Created by Shanshan Zhao on 20/11/2017.
//  Copyright © 2017 Shanshan Zhao. All rights reserved.
//

import Foundation

public struct Weather {
    let info: String
    let icon: String
    let id: Int
    let mainInfo: String
}

extension Weather {
    public init(icon: String, description: String, id: Int, main: String) {
        self.info = description
        self.icon   =  icon
        self.id =  id
        self.mainInfo = main
    }
}

extension Weather: JSONInitializable {
    
    public enum Key: String {
        case info = "description"
        case icon        = "icon"
        case id          = "id"
        case mainInfo        = "main"
    }
    
    public init(with json: JSON) throws {
        self.info = try Weather.value(for: .info, in: json)
        self.icon   = try Weather.value(for: .icon, in: json)
        self.id = try Weather.value(for: .id, in: json) ?? 0
        self.mainInfo = try Weather.value(for: .mainInfo, in: json)
    }
}

