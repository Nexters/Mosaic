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
    
    func requestMyProfile(completion: @escaping (_ code: Int?, _ response: Me?) -> Void) {
        let url = "\(self.url)/apis/me"
        let token = "eyJhbGciOiJIUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAAB3L2wqAIAwA0H_Zc4Jtbpl_M5yCT0UXCKJ_z3o9cG5o-w4Jlnwsa9kqDND0gDQyhZlYBAco1_oDe0T_wXk260dHjWIhOqo8uZBxctrFUTYmlWoxKDwvv9mdDWIAAAA.dqDB6GXYev8adf-GKbOPzghRn0oOH9oof6jvzoNNSy8"
        Alamofire.request(url, method: .get, parameters: nil, headers: ["Authorization": token]).responseObject { (response: DataResponse<Result<Me>>) in
            guard let result = response.result.value?.result else { return }
            completion(response.response?.statusCode, result)
        }
    }
    
    func requestMyScraps(completion: @escaping (_ code: Int?, _ response: [Article]?) -> Void) {
        let url = "\(self.url)/apis/scraps"
        let token = "eyJhbGciOiJIUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAAB3L2wqAIAwA0H_Zc4Jtbpl_M5yCT0UXCKJ_z3o9cG5o-w4Jlnwsa9kqDND0gDQyhZlYBAco1_oDe0T_wXk260dHjWIhOqo8uZBxctrFUTYmlWoxKDwvv9mdDWIAAAA.dqDB6GXYev8adf-GKbOPzghRn0oOH9oof6jvzoNNSy8"
        Alamofire.request(url, method: .get, parameters: nil, headers: ["Authorization": token]).responseObject { (response: DataResponse<ResultArray>) in
            let articles = response.result.value?.result
            completion(response.response?.statusCode, articles)
           
        }
    }
    
    func requestHomeArticles(completion: @escaping (_ code: Int?, _ response: [Article]?) -> Void) {
        let url = "\(self.url)/apis/scripts"
        let token = "eyJhbGciOiJIUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAAB3L2wqAIAwA0H_Zc4Jtbpl_M5yCT0UXCKJ_z3o9cG5o-w4Jlnwsa9kqDND0gDQyhZlYBAco1_oDe0T_wXk260dHjWIhOqo8uZBxctrFUTYmlWoxKDwvv9mdDWIAAAA.dqDB6GXYev8adf-GKbOPzghRn0oOH9oof6jvzoNNSy8"
        Alamofire.request(url, method: .get, parameters: nil, headers: ["Authorization": token]).responseObject { (response: DataResponse<ResultArray>) in
            let articles = response.result.value?.result
            completion(response.response?.statusCode, articles)
            //completion(response.response?.statusCode, result)
        }
    }
    
    func requestMyArticles(completion: @escaping (_ code: Int?, _ response: [Article]?) -> Void) {
        let url = "\(self.url)/apis/scripts/mine"
        let token = "eyJhbGciOiJIUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAAB3L2wqAIAwA0H_Zc4Jtbpl_M5yCT0UXCKJ_z3o9cG5o-w4Jlnwsa9kqDND0gDQyhZlYBAco1_oDe0T_wXk260dHjWIhOqo8uZBxctrFUTYmlWoxKDwvv9mdDWIAAAA.dqDB6GXYev8adf-GKbOPzghRn0oOH9oof6jvzoNNSy8"
        Alamofire.request(url, method: .get, parameters: nil, headers: ["Authorization": token]).responseObject { (response: DataResponse<ResultArray>) in
            let articles = response.result.value?.result
            completion(response.response?.statusCode, articles)
        }
    }
    
    func requestSearchArticles() {
         let url = "\(self.url)/apis/scripts/search"
        
        
        
    }
}

