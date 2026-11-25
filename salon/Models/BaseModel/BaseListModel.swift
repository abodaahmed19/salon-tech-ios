//
//  BaseListModel.swift
//  salon
//
//  Created by AL Badr  on 6/15/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

class BaseListModel<T>: NSObject, Mappable where T: Mappable {
    var status : Bool?
    var data : [T]?
    var message: String?
    var msg: String?
    var error: [String]?
    var meta : Meta?
    var links : Links?
    var pointCount: Int?
    var wallet: String?
    var payable: Double?
    var payment_required: Double?
    var all_balance: String?
    var logout: Bool?
    var errorString: String?

    required init?(map: Map) {
        super.init()
        self.mapping(map: map)
    }
    
    func mapping(map: Map) {
        status <- map["status"]
        data <- map["data"]
        message <- map["message"]
        msg <- map["msg"]
        error <- map["error"]
        errorString <- map["error"]
        meta <- map["meta"]
        links <- map["links"]
        pointCount <- map["pointCount"]
        wallet <- map["wallet"]
        payable <- map["payable"]
        payment_required <- map["payment_required"]
        all_balance <- map["all_balance"]
        logout <- map["logout"]
    }
}
