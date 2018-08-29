//
//  MyProfileService.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 29..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import Alamofire

enum MyProfileService: APIService {
    case me
    case scraps
    
    var path: String {
        switch self {
        case .me:
            return "/apis/me"
        case .scraps:
            return "/apis/scraps"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .me, .scraps:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .me, .scraps:
            return .get
        }
    }
    
    var header: HTTPHeaders? {
        return ["Authorization": APIRouter.token]
    }
}
