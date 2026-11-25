//
//  HomeModel.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

struct HomeModel : Mappable {
    var status : Bool?
    var data : HomeData?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
        data <- map["data"]
    }
    
}
