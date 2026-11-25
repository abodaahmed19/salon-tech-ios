//
//  UserLiveLocation.swift
//  salon
//
//  Created by AL Badr  on 6/30/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import ObjectMapper

class UserLiveLocation: Mappable {
    var speed: Float = 0.0
    var providerId: Int = 0
    var lat: Double = 0.0
    var lon: Double = 0.0
        
    required init?(map: Map) {}
  
    func mapping(map: Map) {
        speed <- map["speed"]
        providerId <- map["providerId"]
        lat <- map["lat"]
        lon <- map["lon"]
    }
    
    
}
