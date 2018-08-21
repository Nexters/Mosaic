//
//  Me.swift
//  Mosaic
//
//  Created by Zedd on 2018. 8. 19..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import ObjectMapper
import Moya

class Result: Mappable {
    var status: Int = 0
    var message: String?
    var code: Int = 0
    var result: Me?
    
    func mapping(map: Map) {
        status <- map["httpStatus"]
        message <- map["message"]
        code <- map["responseCode"]
        result <- map["result"]
    }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
    
}
class Me: Mappable {
    var uuid: String = ""
    var nickName: String = ""
    var university: University?
    var createdAt: Double?
    var updatedAt: Double?
    var authorities: [String]?
    
    func mapping(map: Map) {
        uuid <- map["uuid"]
        nickName <- map["nick"]
        university <- map["university"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        authorities <- map["authorities"]
    }
    required init?(map: Map) {
        self.mapping(map: map)
    }
}

class University {
    var idx: Int = 0
    var name: String = ""
    var domain: String = ""
    var imageUrl: String = ""
}
