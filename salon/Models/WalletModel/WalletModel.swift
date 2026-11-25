//
//  WalletModel.swift
//  salon
//
//  Created by AL Badr  on 6/22/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

struct WalletModel : Mappable {
    var transaction_user_id : String?
    var transaction_type : String?
    var transaction_date : String?
    var transaction_amount : String?
    var transaction_reservation_id : Int?
    var transaction_initial_balance : String?
    var transaction_current_balance : String?
    var transaction_status : String?
    var transaction_user_type : String?
    var transaction_id : Int?
    var transaction_notes : String?
    var reservation : Reservation?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        transaction_user_id <- map["transaction_user_id"]
        transaction_type <- map["transaction_type"]
        transaction_date <- map["transaction_date"]
        transaction_amount <- map["transaction_amount"]
        transaction_reservation_id <- map["transaction_reservation_id"]
        transaction_initial_balance <- map["transaction_initial_balance"]
        transaction_current_balance <- map["transaction_current_balance"]
        transaction_status <- map["transaction_status"]
        transaction_user_type <- map["transaction_user_type"]
        transaction_id <- map["transaction_id"]
        transaction_notes <- map["transaction_notes"]
        reservation <- map["reservation"]
    }

}
