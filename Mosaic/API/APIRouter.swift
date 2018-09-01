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
    var token: String = ""
    var me: Me?
    
    private static let activityIndicator = FullActivityIndicatorView()
    
    func request<T: Mappable>(_ service: APIService, completion: @escaping (_ code: Int?, _ response: T?) -> Void ) {
        APIRouter.activityIndicator.play()
        
        let url = "\(self.baseURL)" + service.path
        Alamofire.request(url,
                          method: service.method,
                          parameters: service.parameters,
                          headers: service.header)
            .responseObject { (response: DataResponse<Result<T>>) in
                APIRouter.activityIndicator.stop()
                let result = response.result.value?.result
                completion(response.response?.statusCode, result)
        }
    }

    func requestArray<T: Mappable>(_ service: APIService, completion: @escaping (_ code: Int?, _ response: [T]?) -> Void) {
        APIRouter.activityIndicator.play()
        
        let url = "\(self.baseURL)" + service.path
        Alamofire.request(url,
                          method: service.method,
                          parameters: service.parameters,
                          headers: service.header)
            .responseObject { (response: DataResponse<Results<T>>) in
                APIRouter.activityIndicator.stop()
                
                let results = response.result.value?.results
                completion(response.response?.statusCode, results)
        }
    }
    
    func upload<T: Mappable>(_ service: APIService, imageKey: String?, images: [UIImage?], completion: @escaping (_ code: Int?, _ response: T?) -> Void ) {
        APIRouter.activityIndicator.play()
        
        let url = "\(self.baseURL)" + service.path
        Alamofire.upload(multipartFormData: { (multipartFormData) in
            for (index, item) in images.enumerated() {
                if let item = item, let imageKey = imageKey {
                    multipartFormData.append(item, key: imageKey, fileName: "\(index)")
                }
            }
            if let parameters = service.parameters as? [String: String] {
                multipartFormData.append(parameters)
            }
        },
                         usingThreshold: UInt64.init(),
                         to: url,
                         method: service.method,
                         headers: service.header) { (encodingResult) in
                            switch encodingResult {
                            case .success(let upload, _, _) :
                                print("인코딩 성공")
                                upload.uploadProgress { progress in
                                    let value = Int(progress.fractionCompleted * 100)
                                    print(value)
                                }
                                upload.responseObject{ (response: DataResponse<Result<T>>) in
                                    APIRouter.activityIndicator.stop()
                                    
                                    let result = response.result.value?.result
                                    completion(response.response?.statusCode, result)
                                }
                            case .failure(let error) :
                                APIRouter.activityIndicator.stop()
                                
                                print(error.localizedDescription)
                            }
        }
    }
}

extension MultipartFormData {
    func append(_ parameters: [String: String]) {
        for (key, value) in parameters {
            guard let data = value.data(using: .utf8) else {return}
            self.append(data, withName: key)
        }
    }
    
    func append(_ image: UIImage, key: String, fileName: String) {
        guard let image = image.compress(toWidth: 512) else {return}
        print(image.description)
        guard let data = UIImagePNGRepresentation(image) else {return}
        self.append(data, withName: key, fileName: fileName+".png", mimeType: "image/png")
    }
}
