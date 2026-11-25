//
//  ArticlesModel.swift
//  salon
//
//  Created by AL Badr  on 6/22/20.
//  Copyright © 2020 ALBadr. All rights reserved.
//

import UIKit
import Foundation
import ObjectMapper

struct ArticlesModel : Mappable {
    var id: Int?
    var title: String?
    var title_en: String?
    var description: String?
    var description_en: String?
    var image: String?
    
    
    init?(map: Map) {
        
    }
    
    init() {}
    
    mutating func mapping(map: Map) {
        id <- map["id"]
        title <- map["title"]
        title_en <- map["title_en"]
        description <- map["description"]
        description_en <- map["description_en"]
        image <- map["image"]
    }
    
}
