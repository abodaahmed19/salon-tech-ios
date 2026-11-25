//
//  SubDepartmentsModel.swift
//  salon
//
//  Created by AL Badr  on 6/14/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

struct SubDepartmentsModel : Mappable {
    var status : Bool?
    var data : [Sub_departments]?
    
    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        status <- map["status"]
        data <- map["data"]
    }
    
}
