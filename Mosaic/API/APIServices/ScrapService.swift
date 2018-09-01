//
//  ScrapService.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 31..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import Alamofire

enum ScrapService: APIService {
    case get(scriptUuid: String)
    case add(scriptUuid: String)
    case delete(scriptUuid: String)
    case getAll
    var path: String {
        switch self {
        case .get, .add, .delete, .getAll :
            return "/apis/scrap"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .get(let scriptUuid), .add(let scriptUuid), .delete(let scriptUuid) :
            return ["scriptUuid": scriptUuid]
        case .getAll:
            return nil
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .get, .getAll:
            return .get
        case .add:
            return .post
        case .delete:
            return .delete
        }
    }

    var header: HTTPHeaders?{
        return ["Authorization": APIRouter.shared.token]
    }
}
