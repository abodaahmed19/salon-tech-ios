//
//  CouponModel.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

struct CouponModel : Mappable {
    var coupon_id : Int?
    var discount : Double?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        coupon_id <- map["coupon_id"]
        discount <- map["discount"]
    }
}
