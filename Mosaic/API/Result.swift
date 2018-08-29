//
//  API.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 29..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import ObjectMapper

//class Result<T: Mappable>: Mappable {
//    
//    var status: Int = 0
//    var message: String?
//    var code: Int = 0
//    var result: T?
//    
//    func mapping(map: Map) {
//        status <- map["httpStatus"]
//        message <- map["message"]
//        code <- map["responseCode"]
//        result <- map["result"]
//    }
//    
//    required init?(map: Map) {
//        self.mapping(map: map)
//    }
//}

class Results<T: Mappable>: Mappable {
    
    var status: Int = 0
    var message: String?
    var code: Int = 0
    var results: [T]?
    
    func mapping(map: Map) {
        status <- map["httpStatus"]
        message <- map["message"]
        code <- map["responseCode"]
        results <- map["result"]
    }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
}
