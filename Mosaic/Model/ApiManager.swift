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
        return "eyJhbGciOiJIUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAACXLSQqAMAwAwL_kbKHRJlF_E9MGelJcQBD_ruJ1YC6o2wYjzLbPS1kdGqi6w4jUUZQBmRso5_IDMtEHx1Hze3ozKdjGIO5dSJPFoEO0QIbqKRdRFrgfNRyYX2IAAAA.HvWhphIPJwbSSqE0hcpWAO1CJn5sKfMMuBQknqcQxmU"
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
    
    func requestHomeArticles(completion: @escaping (_ code: Int?, _ response: [Article]?) -> Void) {
        let url = "\(self.url)/apis/scripts"
        Alamofire.request(url, method: .get, parameters: [:], headers: ["Authorization": self.token]).responseObject { (response: DataResponse<ResultArray>) in
            let articles = response.result.value?.result
            completion(response.response?.statusCode, articles)
        }
    }
    
    func requestArticle(at keyword: String, completion: @escaping (_ code: Int?, _ response: [Article]?) -> Void) {
        let url = "\(self.url)/apis/scripts/search"
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
}

