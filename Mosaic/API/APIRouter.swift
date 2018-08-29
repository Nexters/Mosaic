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
    static let shared = APIRouter()
    static var token: String = ""
    
    func request<T: Mappable>(_ service: APIService, completion: @escaping (_ code: Int?, _ response: T?) -> Void ) {
        let url = "\(self.baseURL)" + service.path
        Alamofire.request(url,
                          method: service.method,
                          parameters: service.parameters,
                          headers: service.header)
            .responseObject { (response: DataResponse<Result<T>>) in
                let result = response.result.value?.result
                completion(response.response?.statusCode, result)
        }
    }

    func requestArray<T: Mappable>(_ service: APIService, completion: @escaping (_ code: Int?, _ response: [T]?) -> Void) {
        let url = "\(self.baseURL)" + service.path
        Alamofire.request(url,
                          method: service.method,
                          parameters: service.parameters,
                          headers: ["Authorization": APIRouter.token])
            .responseObject { (response: DataResponse<Results<T>>) in
                let results = response.result.value?.results
                completion(response.response?.statusCode, results)
        }
    }
    
}
