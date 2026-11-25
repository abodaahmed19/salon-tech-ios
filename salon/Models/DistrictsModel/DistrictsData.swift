//
//  DistrictsData.swift
//  salon
//
//  Created by AL Badr  on 6/28/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import Foundation
import ObjectMapper

struct DistrictsData : Mappable {
    var id: Int?
    var name_ar: String?
    var name_en: String?
    
    init() {}
    
    init?(map: Map) {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        name_ar <- map["name_ar"]
        name_en <- map["name_en"]
    }
}
