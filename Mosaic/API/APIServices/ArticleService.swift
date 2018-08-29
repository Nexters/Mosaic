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
    case get(category: [[String: String]])
    case write(uuid: String, content: String)
    case search(keywork: String)
    case delete(article: Article)
    case mine
    
    var path: String {
        switch self {
        case .delete, .write:
            return "/apis/script"
        case .get:
            return "/apis/scripts"
        case .search:
            return "/apis/scripts/search"
        case .mine:
            return "/apis/scripts/mine"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .search(let keyword):
            return ["keyword"       : keyword]
        case .get(let category):
            return ["categories"    : category]
        case .delete(let article):
            return ["scriptUuid"    : article.uuid!]
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
        case .search, .get, .mine:
            return .get
        case .delete:
            return .delete
        }
    }
    
    var header: HTTPHeaders?{
        print(APIRouter.token)
        return ["Authorization": APIRouter.token]
    }
}

//APIRouter.shared.requestArray(ArticleService.get(category: self.requestCategories)) { (code: Int?, articles: [Article]?) in
//    if code == 200 {
//        self.articles = articles
//        self.collectionView.reloadData()
//    }
//}
