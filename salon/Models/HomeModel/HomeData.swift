//
//  HomeData.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import Foundation
import ObjectMapper

struct HomeData : Mappable {
    var notifications: Int?
    var orders: Int?
    var slider : [Slider]?
    var departments : [DepartmentsData]?
    var articles : [Articles]?
    var providers : [Providers]?

    init?(map: Map) {
        
    }
    
    mutating func mapping(map: Map) {
        notifications <- map["notifications"]
        orders <- map["orders"]
        slider <- map["slider"]
        departments <- map["departments"]
        articles <- map["articles"]
        providers <- map["providers"]
    }
}
