//
//  MessagesModel.swift
//  salon
//
//  Created by AL Badr  on 6/19/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit

import Foundation
import ObjectMapper

struct MessagesModel : Mappable {
    var date : String?
    var client2_status : String?
    var client_id : Int?
    var last_message : String?
    var client_image_url : String?
    var the_date : String?
    var id : Int?
    var client1_status : String?
    var last_message_type : String?
    var receiver_read : Int?
    var client_name : String?

    init?(map: Map) {

    }

    mutating func mapping(map: Map) {
        date <- map["date"]
        client2_status <- map["client2_status"]
        client_id <- map["client_id"]
        last_message <- map["last_message"]
        client_image_url <- map["client_image_url"]
        the_date <- map["the_date"]
        id <- map["id"]
        client1_status <- map["client1_status"]
        last_message_type <- map["last_message_type"]
        receiver_read <- map["receiver_read"]
        client_name <- map["client_name"]
    }

}

