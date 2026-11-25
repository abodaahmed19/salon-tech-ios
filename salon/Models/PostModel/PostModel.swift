//
//  PostModel.swift
//  salon
//
//  Created by AL Badr  on 5/20/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

struct PostModel : Mappable {
    var message : String?
    var msg : String?
    var status : Bool?
    var error : [String]?
    var data : Int?
    var name : String?
    var image_url : String?
    var paymentable_id: Int?
    var errorString: String?
    var verified : String?

    init?(map: Map) {
        
    }
    
    init() {}
    
    mutating func mapping(map: Map) {
        message <- map["message"]
        msg <- map["msg"]
        status <- map["status"]
        error <- map["error"]
        errorString <- map["error"]
        data <- map["data"]
        name <- map["name"]
        image_url <- map["image_url"]
        paymentable_id <- map["paymentable_id"]
        verified <- map["verified"]
    }
    
}
