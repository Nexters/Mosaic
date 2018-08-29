//
//  CategoryService.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 29..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import Alamofire

enum CategoryService: APIService {
    case get
    
    var path: String {
        switch self {
        case .get:
            return "/categories"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .get:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .get:
            return .get
        }
    }
    
    var header: HTTPHeaders? {
        return ["Authorization": APIRouter.token]
    }
}
