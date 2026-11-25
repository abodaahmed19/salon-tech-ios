//
//  CitiesData.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import Foundation
import ObjectMapper

struct CitiesData : Mappable {
    var city_id: Int?
    var city_name: String?
    var city_name_en: String?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        city_id <- map["city_id"]
        city_name <- map["city_name"]
        city_name_en <- map["city_name_en"]
    }
}
