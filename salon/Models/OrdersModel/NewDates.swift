//
//  NewDates.swift
//  salon
//
//  Created by AL Badr  on 6/29/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//


import Foundation
import ObjectMapper

class NewDates : Mappable {
    var suggest_id  : Int?
    var suggest_time : String = ""
    var suggest_service_id : String?
    var suggest_to : String?
    var suggest_date : String?
    
    var suggestTimeAPI: String = ""
    
    init() {}
    
    required init?(map: Map) {}

    func mapping(map: Map) {
        suggest_time <- map["suggest_time"]
        suggest_service_id <- map["suggest_service_id"]
        suggest_to <- map["suggest_to"]
        suggest_id  <- map["suggest_id"]
        suggest_date <- map["suggest_date"]
    }
    
    func checkConvertTime() -> Bool {
        var sugTime = suggest_time
        
        sugTime = sugTime.replacingOccurrences(of: "ص", with: "AM")
        sugTime = sugTime.replacingOccurrences(of: "م", with: "PM")

        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "yyyy-MM-dd h:mm a"
        timeFormatter.locale = Locale(identifier: "en_US_POSIX")
        timeFormatter.calendar = Calendar(identifier: .gregorian)
        timeFormatter.isLenient = false

        print("suggest_time", sugTime)
    
        guard let time = timeFormatter.date(from: sugTime) else { return false }
        
        if Date() > time {
            return false
        }
        
        let newTimeFormatter = DateFormatter()
        newTimeFormatter.dateFormat = "HH:mm:ss"
        newTimeFormatter.locale = Locale(identifier: "en")

        suggestTimeAPI = newTimeFormatter.string(from: time)
        return true
    }

}
