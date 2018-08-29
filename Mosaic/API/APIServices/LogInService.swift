//
//  Service.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 29..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import Alamofire

enum LogInService: APIService {
    case email(value: String)
    case token(value: User)
    
    var path: String {
        switch self {
        case .email:
            return "/login/email"
        case .token:
            return "/login/token"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .email(let email):
            return ["email": email]
        case .token(let user):
            return ["authKey": user.authKey, "uuid": user.uuid]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .email:
            return .post
        case .token:
            return .post
        }
    }
    
    var header: HTTPHeaders?{
        switch self {
        default:
            return nil
        }
    }
}
