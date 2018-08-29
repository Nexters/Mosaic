//
//  BookMarkService.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 29..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import Alamofire

enum BookMarkService: APIService {
    case add(article: Article)
    case delete(article: Article)
    var path: String {
        switch self {
        case .add, .delete:
            return "/apis/scrap"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .add(let article):
            return ["scriptUuid" : article.uuid!]
        case .delete(let article):
            return ["scriptUuid" : article.uuid!]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .add:
            return .post
        case .delete:
            return .delete
        }
    }
    
    var header: HTTPHeaders?{
        return ["Authorization": APIRouter.token]
    }
}
