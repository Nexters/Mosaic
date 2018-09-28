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

class Result<T: Mappable>: Mappable {
    
    var status: Int = 0
    var message: String?
    var code: Int = 0
    var result: T?
    
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


class ResultArray: Mappable {
    
    var status: Int = 0
    var message: String?
    var code: Int = 0
    var result: [Article]?
    
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

class ResutlCategories: Mappable {
    var status: Int = 0
    var message: String?
    var code: Int = 0
    var result: [Categories]?
    
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
    var email: String?
    var scrapCount: Int = 0
    var articleCount: Int = 0
    
    func mapping(map: Map) {
        uuid <- map["uuid"]
        nickName <- map["nick"]
        university <- map["university"]
        createdAt <- map["createdAt"]
        updatedAt <- map["updatedAt"]
        authorities <- map["authorities"]
        email <- map["email"]
        scrapCount <- map["myScrapCnt"]
        articleCount <- map["myScriptCnt"]
    }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
}

class University: Mappable {
    
    var idx: Int = 0
    var name: String = ""
    var domain: String = ""
    var imageUrl: String = ""
    
    func mapping(map: Map) {
        idx <- map["idx"]
        name <- map["name"]
        domain <- map["domain"]
        imageUrl <- map["imgUrl"]
    }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
}

typealias Category = (emoji: String, title: String)
class Categories: Mappable {
    
    var emoji: String = ""
    var idx: Int = 0
    var name: String = ""
    var uuid: String = ""
    lazy var emojiTitle: Category = (emoji: self.emoji, title: self.name)
   
    func mapping(map: Map) {
        emoji <- map["emoji"]
        idx <- map["idx"]
        name <- map["name"]
        uuid <- map["uuid"]
    }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
}

class Article: Mappable {
    
    var category: Categories?
    var content: String?
    var createdAt: Int = 0
    var idx: Int = 0
    var imageUrls: [String]?
    var replies: Int = 0
    var isScraped: Bool = false
    var thumbnailUrls: [String]?
    var uuid: String?
    var valid: Bool = true
    var writer: Me?
    
    func mapping(map: Map) {
        category <- map["category"]
        content <- map["content"]
        createdAt <- map["createdAt"]
        idx <- map["idx"]
        imageUrls <- map["imgUrls"]
        replies <- map["replies"]
        isScraped <- map["scrap"]
        thumbnailUrls <- map["thumbnailUrls"]
        uuid <- map["uuid"]
        valid <- map["valid"]
        writer <- map["writer"]
    }
    
    required init?(map: Map) {
        self.mapping(map: map)
    }
}
