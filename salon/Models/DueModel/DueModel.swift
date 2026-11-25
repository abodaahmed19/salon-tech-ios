//
//  DueModel.swift
//  salon
//
//  Created by AL Badr  on 7/12/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

struct DueModel : Mappable {
    var payable_to_provider : String?
    var reservation_commission_money : String?
    var admin_agree : String?
    var reservation_add_value : String?
    var reservation_id : Int?
    var reservation_date : String?
    var reservation_rest : String?
    var reservation_money_required : String?
    var provider_id : Int?
    var reservation_money_paid : String?
    var reservation_total : String?
    var required_from_provider : String?
    var status : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        payable_to_provider <- map["payable_to_provider"]
        reservation_commission_money <- map["reservation_commission_money"]
        admin_agree <- map["admin_agree"]
        reservation_add_value <- map["reservation_add_value"]
        reservation_id <- map["reservation_id"]
        reservation_date <- map["reservation_date"]
        reservation_rest <- map["reservation_rest"]
        reservation_money_required <- map["reservation_money_required"]
        provider_id <- map["provider_id"]
        reservation_money_paid <- map["reservation_money_paid"]
        reservation_total <- map["reservation_total"]
        required_from_provider <- map["required_from_provider"]
        status <- map["status"]
    }
    
}
