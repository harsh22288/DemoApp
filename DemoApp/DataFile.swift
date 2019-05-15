//
//  DataFile.swift
//  DemoApp
//
//  Created by  Harsh Saxena on 14/05/19.
//  Copyright © 2019  Harsh Saxena. All rights reserved.
//

import Foundation

struct DataFile: Comparable {
    var id : Int
    var latitude: Double
    var longtiude: Double
    var country: String
    var name: String
    
    
    
    init(id: Int, latitude: Double, longitude: Double, country: String, name:String) {
        self.id = id
        self.latitude = latitude
        self.longtiude = longitude
        self.country = country
        self.name = name
        
    }
    
    init() {
        id = 0
        latitude = 0.0
        longtiude = 0.0
        country = ""
        name = ""
    }
    
}

func < (lhs: DataFile, rhs: DataFile) -> Bool {
    return lhs.name < rhs.name
}

func == (lhs: DataFile, rhs: DataFile) -> Bool {
    return lhs.name == rhs.name
}
