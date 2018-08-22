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
        return "http://13.209.57.250:8080"
    }
    func requestMyProfile() {
//        let url = "\(self.url)/apis/me"
//        let token = "eyJhbGciOiJIUzI1NiIsInppcCI6IkdaSVAifQ.H4sIAAAAAAAAACXLSQrAIAwAwL_krAeNS9rfBBfwpFSFQunfG-h1YB5oc8IJPa0-ylVBQeMFp_HoCCOiV1Du8cNhRQT2blkOG6aQHWmsPmqXbNQsojFljxxqJsfwfko7sXpiAAAA.JkE8nuI5sia4ABo2ShH6oSGjuUSf1HypXuncuqOWs48"
//        Alamofire.request(url, method: .get, parameters: nil, headers: ["Authorization": token]).responseObject { (response: DataResponse<Result<Me>>) in
//            let result = response.result.value
//            let me = result?.result?.nickName
//            print(me)
//        }
    }
    
    func requestCategory() {
        let url = "\(self.url)/categories"
        Alamofire.request(url).responseArray { (response: DataResponse<[Result]>) in
            let result = response.result.value
           print(result)
        }
    }
}

