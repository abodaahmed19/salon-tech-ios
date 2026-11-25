//
//  ChooseProviderModel.swift
//  salon
//
//  Created by AL Badr  on 6/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import Foundation
import ObjectMapper

struct ChooseProviderModel : Mappable {
    var user_id : Int?
    var user_name : String?
    var user_image : String?
    var user_address : String?
    var verified : Bool?
    var verified_user : Bool?
    var rate : Int?
    var imageIdentity : String?
    var discount : String?
    var listImages : [String]?
    var bio : String?
    var cover : String?
    var cover_type : String?
    var isFav : Bool?
    var certified_status : Bool?
    var certifiedFrom : String?
    var certified_image : String?
    var reservations_ended_count : Int?

    init?(map: Map) {}

    mutating func mapping(map: Map) {
        user_id <- map["user_id"]
        user_name <- map["user_name"]
        user_image <- map["user_image"]
        user_address <- map["user_address"]
        verified <- map["verified"]
        verified_user <- map["verified_user"]
        rate <- map["rate"]
        imageIdentity <- map["imageIdentity"]
        discount <- map["discount"]
        listImages <- map["listImages"]
        bio <- map["bio"]
        cover <- map["cover"]
        cover_type <- map["cover_type"]
        isFav <- map["isFav"]
        certified_status <- map["certified_status"]
        certifiedFrom <- map["certifiedFrom"]
        certified_image <- map["certified_image"]
        reservations_ended_count <- map["reservations_ended_count"]
    }

}
