//
//  APIs.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 29..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import ObjectMapper

class Token: Mappable {
    var header: String = ""
    
    func mapping(map: Map) {
        header <-  map["token"]
    }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
}

class User: Mappable {
    var authKey: String = ""
    var uuid: String = ""
    
    func mapping(map: Map) {
        authKey <-  map["authKey"]
        uuid    <-  map["uuid"]
    }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
}

class Reply: Mappable {
    var content: String = ""
    var createdAt: Int = 0
    var depth: Int = 0
    var idx: Int = 0
    var imgUrl: String?
    var scriptUuid: String = ""
    var thumbnailUrl: String?
    var updatedAt: Int = 0
    var upperReplyNick: String = ""
    var upperReplyUuid: String = ""
    var uuid: String = ""
    var writer: Me?

    func mapping(map: Map) {
        content         <- map["content"]
        createdAt       <- map["createdAt"]
        depth           <- map["depth"]
        idx             <- map["idx"]
        imgUrl          <- map["imgUrl"]
        scriptUuid      <- map["scriptUuid"]
        thumbnailUrl    <- map["thumbnailUrl"]
        updatedAt       <- map["updatedAt"]
        upperReplyNick  <- map["upperReplyNick"]
        upperReplyUuid  <- map["upperReplyUuid"]
        uuid            <- map["uuid"]
        writer          <- map["writer"]
    }

    required init?(map: Map) {
        self.mapping(map: map)
    }
}

extension Reply: Equatable {
    static func ==(lhs: Reply, rhs: Reply) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}


