//
//  ReservationModel.swift
//  salon
//
//  Created by AL Badr  on 6/15/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class ReservationModel: NSObject, NSCoding, Mappable {
    var reservation_id: Int?
    var provider_id: Int?
    var address: String?
    var lat: String?
    var lon: String?
    var comment: String?
    var date: String?
    var time: String?
    var coupon_id: Int?
    var coupon_percentage: Double?
    var city_id: String?
    var main_service_ids: [Int]?
    var service_ids: [Int]?
    var services_total: Double?
    var subDepartments: [DepartmentsData]?
    var sensitivity: Int?

    override init() {}
    
    required init?(map: Map) {}
    
    required init(coder decoder: NSCoder) {
        self.reservation_id = decoder.decodeObject(forKey: "reservation_id")  as? Int ?? 0
        self.provider_id = decoder.decodeObject(forKey: "provider_id")  as? Int ?? 0
        self.address = decoder.decodeObject(forKey: "address") as? String ?? ""
        self.lat = decoder.decodeObject(forKey: "lat") as? String ?? ""
        self.lon = decoder.decodeObject(forKey: "lon") as? String ?? ""
        self.comment = decoder.decodeObject(forKey: "comment") as? String ?? ""
        self.date = decoder.decodeObject(forKey: "date") as? String ?? ""
        self.time = decoder.decodeObject(forKey: "time") as? String ?? ""
        self.coupon_id = decoder.decodeObject(forKey: "coupon_id")  as? Int ?? 0
        self.coupon_percentage = decoder.decodeObject(forKey: "coupon_percentage")  as? Double ?? 0
        self.city_id = decoder.decodeObject(forKey: "city_id")  as? String ?? ""
        self.main_service_ids = decoder.decodeObject(forKey: "main_service_ids") as? [Int] ?? []
        self.service_ids = decoder.decodeObject(forKey: "service_ids") as? [Int] ?? []
        self.subDepartments = decoder.decodeObject(forKey: "subDepartments") as? [DepartmentsData] ?? []
        self.services_total = decoder.decodeObject(forKey: "services_total") as? Double ?? 0
        self.sensitivity = decoder.decodeObject(forKey: "sensitivity")  as? Int ?? 0
    }
    
    func mapping(map: Map) {
        reservation_id <- map["reservation_id"]
        provider_id <- map["provider_id"]
        address <- map["address"]
        lat <- map["lat"]
        lon <- map["lon"]
        comment <- map["comment"]
        date <- map["date"]
        time <- map["time"]
        coupon_id <- map["coupon_id"]
        coupon_percentage <- map["coupon_percentage"]
        city_id <- map["city_id"]
        main_service_ids <- map["main_service_ids"]
        service_ids <- map["service_ids"]
        subDepartments <- map["subDepartments"]
        services_total <- map["services_total"]
        sensitivity <- map["sensitivity"]
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(reservation_id ,forKey: "reservation_id")
        coder.encode(provider_id ,forKey: "provider_id")
        coder.encode(address ,forKey: "address")
        coder.encode(lat ,forKey: "lat")
        coder.encode(lon ,forKey: "lon")
        coder.encode(comment ,forKey: "comment")
        coder.encode(date ,forKey: "date")
        coder.encode(time ,forKey: "time")
        coder.encode(coupon_id ,forKey: "coupon_id")
        coder.encode(coupon_percentage ,forKey: "coupon_percentage")
        coder.encode(city_id ,forKey: "city_id")
        coder.encode(main_service_ids ,forKey: "main_service_ids")
        coder.encode(service_ids ,forKey: "service_ids")
        coder.encode(subDepartments ,forKey: "subDepartments")
        coder.encode(services_total ,forKey: "services_total")
        coder.encode(sensitivity, forKey: "sensitivity")
    }
}
