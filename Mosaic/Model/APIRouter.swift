//
//  APIRoute.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 28..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import Alamofire
import ObjectMapper

class APIRouter {
    
    static var shared = APIRouter()
    
    enum LogIn {
        case email(value: String)
        case token(authKey: String, uuid: String)
        
        var path: String {
            switch self {
            case .email:
                return "/login/email"
            case .token:
                return "/login/token"
            }
        }
        
        var pameters: Parameters? {
            switch self {
            case .email(let email):
                return ["email": email]
            case .token(let authKey, let uuid):
                return ["authKey": authKey, "uuid": uuid]
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
    
    func request<T: Mappable>(logIn: LogIn, completion: @escaping (_ code: Int?, _ response: T?) -> Void ) {
        let url = "\(self.baseURL)" + logIn.path
        Alamofire.request(url,
                          method: logIn.method,
                          parameters: logIn.pameters,
                          headers: logIn.header)
            .responseObject { (response: DataResponse<Result<T>>) in
                let value = response.result.value
                let result = response.result.value?.result
//                completion(response.response?.statusCode, result)
        }
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


