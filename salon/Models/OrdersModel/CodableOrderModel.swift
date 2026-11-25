//
//  CodableOrderModel.swift
//  salon
//
//  Created by AL Badr  on 10/1/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation


struct CodableOrderModel : Decodable {
    var status : Bool = false
    var data : [CodableOrderModelData]?
    var mewssage : String = ""
    
    
    enum CodingKeys: String, CodingKey {
        case status = "status"
        case data = "data"
        case mewssage = "mewssage"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        
        self.status = (try values.decodeIfPresent(Bool.self, forKey: .status)) ?? false
        self.mewssage = (try values.decodeIfPresent(String.self, forKey: .mewssage)) ?? ""
//        self.data = ((try values.decodeIfPresent([CodableOrderModelData?].self, forKey: .data)) ?? []).compactMap { $0 }
        
        if let data = try? values.decodeIfPresent([CodableOrderModelData].self, forKey: .data) {
            self.data = data
        } else {
            self.data = []
        }
    }
    
}

struct CodableOrderModelData : Decodable {
    let reservation_paymentType : String?
//    let reservation_client_name : String?
//    let reservation_total : String?
//    let reservation_time : String?
//    let reservation_comment : String?
//    let reservation_client_id : String?
//    let reservation_provider_name : String?
//    let reservation_suggest_newTime : [NewDatesCodable]?
//    let reservation_money_pay_points : Int?
//    let reservation_net : String?
//    let reservation_cancel_reason : String?
//    let reservation_money_pay : String?
//    let reservation_net_points : Int?
//    let reservation_lon : String?
//    let reservation_id : Int?
//    let reservation_if_follow_open : Bool?
//    let reservation_details : [ReservationDetails]?
//    let reservation_addedValue  : Int?
//    let reservation_address : String?
//    let reservation_if_client_end : Bool?
//    let reservation_if_provider_end : Bool?
//    let reservation_rest : String?
//    let reservation_date : String?
//    let reservation_client_image : String?
//    let reservation_status : String?
//    let reservation_provider_id : String?
//    let reservation_addValue : String?
//    let reservation_lat : String?
//    let reservation_provider_image : String?
    
    enum CodingKeys: String, CodingKey {
        case reservation_paymentType = "reservation_paymentType"
//        case reservation_client_name = "reservation_client_name"
//        case reservation_total = "reservation_total"
//        case reservation_time = "reservation_time"
//        case reservation_comment = "reservation_comment"
//        case reservation_client_id = "reservation_client_id"
//        case reservation_provider_name = "reservation_provider_name"
//        case reservation_suggest_newTime = "reservation_suggest_newTime"
//        case reservation_money_pay_points = "reservation_money_pay_points"
//        case reservation_net = "reservation_net"
//        case reservation_cancel_reason = "reservation_cancel_reason"
//        case reservation_money_pay = "reservation_money_pay"
//        case reservation_net_points = "reservation_net_points"
//        case reservation_lon = "reservation_lon"
//        case reservation_id = "reservation_id"
//        case reservation_if_follow_open = "reservation_if_follow_open"
//        case reservation_details = "reservation_details"
//        case reservation_addedValue  = "reservation_addedValue "
//        case reservation_address = "reservation_address"
//        case reservation_if_client_end = "reservation_if_client_end"
//        case reservation_if_provider_end = "reservation_if_provider_end"
//        case reservation_rest = "reservation_rest"
//        case reservation_date = "reservation_date"
//        case reservation_client_image = "reservation_client_image"
//        case reservation_status = "reservation_status"
//        case reservation_provider_id = "reservation_provider_id"
//        case reservation_addValue = "reservation_addValue"
//        case reservation_lat = "reservation_lat"
//        case reservation_provider_image = "reservation_provider_image"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
//        reservation_paymentType = try values.decodeIfPresent(String.self, forKey: .reservation_paymentType)
        
        if let reservation_paymentType = try? values.decodeIfPresent(String.self, forKey: .reservation_paymentType) {
            self.reservation_paymentType = reservation_paymentType
        } else {
            self.reservation_paymentType = "[]"
        }
        
        
        
//        reservation_client_name = try values.decodeIfPresent(String.self, forKey: .reservation_client_name)
//        reservation_total = try values.decodeIfPresent(String.self, forKey: .reservation_total)
//        reservation_time = try values.decodeIfPresent(String.self, forKey: .reservation_time)
//        reservation_comment = try values.decodeIfPresent(String.self, forKey: .reservation_comment)
//        reservation_client_id = try values.decodeIfPresent(String.self, forKey: .reservation_client_id)
//        reservation_provider_name = try values.decodeIfPresent(String.self, forKey: .reservation_provider_name)
//        reservation_suggest_newTime = try values.decodeIfPresent([NewDatesCodable].self, forKey: .reservation_suggest_newTime)
//        reservation_money_pay_points = try values.decodeIfPresent(Int.self, forKey: .reservation_money_pay_points)
//        reservation_net = try values.decodeIfPresent(String.self, forKey: .reservation_net)
//        reservation_cancel_reason = try values.decodeIfPresent(String.self, forKey: .reservation_cancel_reason)
//        reservation_money_pay = try values.decodeIfPresent(String.self, forKey: .reservation_money_pay)
//        reservation_net_points = try values.decodeIfPresent(Int.self, forKey: .reservation_net_points)
//        reservation_lon = try values.decodeIfPresent(String.self, forKey: .reservation_lon)
//        reservation_id = try values.decodeIfPresent(Int.self, forKey: .reservation_id)
//        reservation_if_follow_open = try values.decodeIfPresent(Bool.self, forKey: .reservation_if_follow_open)
//        reservation_details = try values.decodeIfPresent([ReservationDetails].self, forKey: .reservation_details)
//        reservation_addedValue  = try values.decodeIfPresent(Int.self, forKey: .reservation_addedValue )
//        reservation_address = try values.decodeIfPresent(String.self, forKey: .reservation_address)
//        reservation_if_client_end = try values.decodeIfPresent(Bool.self, forKey: .reservation_if_client_end)
//        reservation_if_provider_end = try values.decodeIfPresent(Bool.self, forKey: .reservation_if_provider_end)
//        reservation_rest = try values.decodeIfPresent(String.self, forKey: .reservation_rest)
//        reservation_date = try values.decodeIfPresent(String.self, forKey: .reservation_date)
//        reservation_client_image = try values.decodeIfPresent(String.self, forKey: .reservation_client_image)
//        reservation_status = try values.decodeIfPresent(String.self, forKey: .reservation_status)
//        reservation_provider_id = try values.decodeIfPresent(String.self, forKey: .reservation_provider_id)
//        reservation_addValue = try values.decodeIfPresent(String.self, forKey: .reservation_addValue)
//        reservation_lat = try values.decodeIfPresent(String.self, forKey: .reservation_lat)
//        reservation_provider_image = try values.decodeIfPresent(String.self, forKey: .reservation_provider_image)
    }
    
}

struct ReservationDetails : Codable {
    var details_id : Int?
    var details_price : String?
    var details_department_name : String?
    var details_department_name_en : String?
    
    
    enum CodingKeys: String, CodingKey {
        case details_id = "details_id"
        case details_price = "details_price"
        case details_department_name = "details_department_name"
        case details_department_name_en = "details_department_name_en"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        details_id = try values.decodeIfPresent(Int.self, forKey: .details_id)
        details_price = try values.decodeIfPresent(String.self, forKey: .details_price)
        details_department_name = try values.decodeIfPresent(String.self, forKey: .details_department_name)
        details_department_name_en = try values.decodeIfPresent(String.self, forKey: .details_department_name_en)
    }
    
}

struct NewDatesCodable : Codable {
    var suggest_id  : Int?
    var suggest_time : String?
    var suggest_service_id : String?
    var suggest_to : String?
    var suggest_date : String?
    
    var suggestTimeAPI: String = ""
    
    enum CodingKeys: String, CodingKey {
        case suggest_id = "suggest_id"
        case suggest_time = "suggest_time"
        case suggest_service_id = "suggest_service_id"
        case suggest_to = "suggest_to"
        case suggest_date = "suggest_date"
        case suggestTimeAPI = "suggestTimeAPI"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        suggest_id = try values.decodeIfPresent(Int.self, forKey: .suggest_id)
        suggest_time = try values.decodeIfPresent(String.self, forKey: .suggest_time)
        suggest_service_id = try values.decodeIfPresent(String.self, forKey: .suggest_service_id)
        suggest_to = try values.decodeIfPresent(String.self, forKey: .suggest_to)
        suggest_date = try values.decodeIfPresent(String.self, forKey: .suggest_date)
    }
    
    mutating func convertTime() {
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "h:mm a"
        let time = timeFormatter.date(from: suggest_time ?? "")
        
        let newTimeFormatter = DateFormatter()
        newTimeFormatter.dateFormat = "HH:mm:ss"
        self.suggestTimeAPI = newTimeFormatter.string(from: time ?? Date())
    }
}

