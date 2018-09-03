//
//  Article.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 29..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import Alamofire

enum ArticleService: APIService {
    case get(scriptUuid: String)
    case getAll(category: [String])
    case write(uuid: String, content: String)
    case search(keywork: String)
    case delete(scriptUuid: String)
    case mine
    
    var path: String {
        switch self {
        case .get, .delete, .write:
            return "/apis/script"
        case .getAll:
            return "/apis/scripts"
        case .search:
            return "/apis/scripts/search"
        case .mine:
            return "/apis/scripts/mine"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .get(let scriptUuid):
            return ["scriptUuid"    : scriptUuid]
        case .search(let keyword):
            return ["keyword"       : keyword]
        case .getAll(let category):
            return ["categories"    : category]
        case .delete(let scriptUuid):
            return ["scriptUuid"    : scriptUuid]
        case .mine:
            return nil
        case .write(let uuid, let content):
            return ["categoryUuid"  : uuid,
                    "content"       : content]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .write:
            return .post
        case .get, .search, .getAll, .mine:
            return .get
        case .delete:
            return .delete
        }
    }
    
    var header: HTTPHeaders?{
        return ["Authorization": APIRouter.shared.token]
    }
}

//APIRouter.shared.requestArray(ArticleService.get(category: self.requestCategories)) { (code: Int?, articles: [Article]?) in
//    if code == 200 {
//        self.articles = articles
//        self.collectionView.reloadData()
//    }
//}
