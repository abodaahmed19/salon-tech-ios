//
//  CitiesModel.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

struct CitiesModel : Mappable {
    var status : Bool?
    var data : [CitiesData]?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {

        status <- map["status"]
        data <- map["data"]
    }

}
