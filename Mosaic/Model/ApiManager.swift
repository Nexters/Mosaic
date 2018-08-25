//
//  ApiManager.swift
//  Mosaic
//
//  Created by Zedd on 2018. 8. 19..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import AlamofireObjectMapper
import Alamofire

class ApiManager {
    
    static let shared: ApiManager = ApiManager()
    
    var url: String {
        return ""
    }
    
    var token: String  {
        return "eyJhbGciOiJIUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAACXLSwqAIBAA0LvMWiE_o-Ztxh-4UlIhiO5e0fbBu6COAR5anK3nowCDShO8QIXCGL1bBvnsP0iU7oO1anoPqlxiiIlHkorrbC0ntRlOpViDwSUhNdwPyesGPGIAAAA.BMewenYjwxnPZUpKkysyCuh4_0LhmGYlPA6AUlMpg1s"
    }
    
    func requestMyProfile(completion: @escaping (_ code: Int?, _ response: Me?) -> Void) {
        let url = "\(self.url)/apis/me"
        
        Alamofire.request(url, method: .get, parameters: nil, headers: ["Authorization": self.token]).responseObject { (response: DataResponse<Result<Me>>) in
            guard let result = response.result.value?.result else { return }
            completion(response.response?.statusCode, result)
        }
    }
    
    func requestMyScraps(completion: @escaping (_ code: Int?, _ response: [Article]?) -> Void) {
        let url = "\(self.url)/apis/scraps"
        
        Alamofire.request(url, method: .get, parameters: nil, headers: ["Authorization": self.token]).responseObject { (response: DataResponse<ResultArray>) in
            let articles = response.result.value?.result
            completion(response.response?.statusCode, articles)
           
        }
    }
    
    func requestHomeArticles(with category: [[String: String]], completion: @escaping (_ code: Int?, _ response: [Article]?) -> Void) {
        let url = "\(self.url)/apis/scripts"
   
        let dd: [String: Any] = [
            "categories" : ["7d798e3e-cb09-4fde-9158-f43f84c0cb4f", "f9afc3ad-999d-4ceb-8381-11a1bd176bf1"]
        ]

        Alamofire.request(url, method: .get, parameters: dd, headers: ["Authorization": self.token]).responseObject { (response: DataResponse<ResultArray>) in
            let articles = response.result.value?.result
            completion(response.response?.statusCode, articles)
        }
    }
    
    func requestArticle(at keyword: String, completion: @escaping (_ code: Int?, _ response: [Article]?) -> Void) {
        let url = "\(self.url)/apis/scripts/search"
        print(keyword)
        Alamofire.request(url, method: .get, parameters: ["keyword": keyword], headers: ["Authorization": self.token]).responseObject { (response: DataResponse<ResultArray>) in
            let articles = response.result.value?.result
            completion(response.response?.statusCode, articles)
        }
    }
    
    func requestMyArticles(completion: @escaping (_ code: Int?, _ response: [Article]?) -> Void) {
        let url = "\(self.url)/apis/scripts/mine"
        Alamofire.request(url, method: .get, parameters: nil, headers: ["Authorization": self.token]).responseObject { (response: DataResponse<ResultArray>) in
            let articles = response.result.value?.result
            completion(response.response?.statusCode, articles)
        }
    }
    
    func requestCategories(completion: @escaping (_ code: Int?, _ response: [Categories]?) -> Void) {
        let url = "\(self.url)/categories"
        Alamofire.request(url, method: .get).responseObject { (response: DataResponse<ResutlCategories>) in
            let categories = response.result.value?.result
            completion(response.response?.statusCode, categories)
        }
    }
    
    func updateBookMark(type: BookMarkType, article: Article, completion: @escaping (_ code: Int?, _ response: Article?) -> Void) {
        let url = "\(self.url)/apis/scrap"
        let parameter: [String: Any] = [
            "scriptUuid" : article.uuid!
        ]
        print(parameter)
        Alamofire.request(url, method: type.method, parameters: parameter, headers:  ["Authorization": self.token]).responseObject { (response: DataResponse<Result<Article>>) in
            let categories = response.result.value?.result
            completion(response.response?.statusCode, categories)
        }
    }
    
    func updateMyArticle(type: ArticleType, article: Article, completion: @escaping (_ code: Int?, _ response: Article?) -> Void) {
        let url = "\(self.url)/apis/script"
        var parameter: [String: Any] = [:]
        switch type {
        case .add:
            parameter = [:]
        case .delete:
            parameter = [
                "scriptUuid" : article.uuid!
            ]
        }
        print(parameter)
        Alamofire.request(url, method: type.method, parameters: parameter, headers:  ["Authorization": self.token]).responseObject { (response: DataResponse<Result<Article>>) in
            let categories = response.result.value?.result
            completion(response.response?.statusCode, categories)
        }
    }
    
    
}
enum ArticleType {
    case add
    case delete
    var method: HTTPMethod {
        switch self {
        case .add:
            return .post
        case .delete :
            return .delete
        }
    }
}

enum BookMarkType {
    case add
    case delete
    
    var method: HTTPMethod {
        switch self {
        case .add:
            return .post
        case .delete :
            return .delete
        }
    }
}

