//
//  ColorsModel.swift
//  salon
//
//  Created by AL Badr  on 7/16/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

class ColorsModel: NSObject, NSCoding, Mappable {
    var clock_div : String?
    var top_div : String?
    var top_div_line : String?
    var bottom_div : String?
    var side_menu : String?
    var price_line : String?
    
    override init() {}
    
    required init?(map: Map) {}
        
    func mapping(map: Map) {
        clock_div <- map["clock_div"]
        top_div <- map["top_div"]
        top_div_line <- map["top_div_line"]
        bottom_div <- map["bottom_div"]
        side_menu <- map["side_menu"]
        price_line <- map["price_line"]
    }
    
    required init(coder decoder: NSCoder) {
        self.clock_div = decoder.decodeObject(forKey: "clock_div") as? String ?? ""
        self.top_div = decoder.decodeObject(forKey: "top_div") as? String ?? ""
        self.top_div_line = decoder.decodeObject(forKey: "top_div_line") as? String ?? ""
        self.bottom_div = decoder.decodeObject(forKey: "bottom_div") as? String ?? ""
        self.side_menu = decoder.decodeObject(forKey: "side_menu") as? String ?? ""
        self.price_line = decoder.decodeObject(forKey: "price_line") as? String ?? ""
    }
    
    func encode(with coder: NSCoder) {
        coder.encode(clock_div, forKey: "clock_div")
        coder.encode(top_div, forKey: "top_div")
        coder.encode(top_div_line, forKey: "top_div_line")
        coder.encode(bottom_div, forKey: "bottom_div")
        coder.encode(side_menu, forKey: "side_menu")
        coder.encode(price_line, forKey: "price_line")
    }
}
