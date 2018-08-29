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

 


