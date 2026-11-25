//
//  PointsModel.swift
//  salon
//
//  Created by AL Badr  on 6/22/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

struct PointsModel : Mappable {
    var point_statement : String?
    var point_id : Int?
    var point_amount_required : String?
    var point_amount_paid_points : Int?
    var point_reservation_id : Int?
    var point_practical_points : String?
    var point_count_point : Int?
    var point_amount_paid : String?
    var point_user_id : Int?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        point_statement <- map["point_statement"]
        point_id <- map["point_id"]
        point_amount_required <- map["point_amount_required"]
        point_amount_paid_points <- map["point_amount_paid_points"]
        point_reservation_id <- map["point_reservation_id"]
        point_practical_points <- map["point_practical_points"]
        point_count_point <- map["point_count_point"]
        point_amount_paid <- map["point_amount_paid"]
        point_user_id <- map["point_user_id"]
    }

}
