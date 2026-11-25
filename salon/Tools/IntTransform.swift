//
//  IntTransform.swift
//  salon
//
//  Created by Mahmoud Elzaiady on 20/09/2022.
//  Copyright © 2022 ALBadr. All rights reserved.
//

import Foundation
import ObjectMapper

class IntTransform: TransformType {
    typealias Object = Int
    typealias JSON = Any?
    
    init() {}
    
    func transformFromJSON(_ value: Any?) -> Int? {
        var result: Int?
        
        guard let json = value else {
            return result
        }
        
        if json is Int {
            result = (json as! Int)
        }
        
        if json is String {
            result = Int(json as! String)
        }
        
        return result
    }
    
    func transformToJSON(_ value: Int?) -> Any?? {
        guard let object = value else {
            return nil
        }
        
        return String(object)
    }
}
