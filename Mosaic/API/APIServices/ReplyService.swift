//
//  ReplyService.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 30..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import Alamofire

enum ReplyService: APIService {
    case getReplies(scriptUuid: String)
    case add(content: String, scriptUuid: String, upperReplyUuid: String)
    case delete(replyUuid: String)
    
    var path: String {
        switch self {
        case .getReplies:
            return "/apis/replies"
        case .add, .delete:
            return "/apis/reply"
        }
    }
    
    var parameters: Parameters? {
        switch self {
        case .getReplies(let scriptUuid):
            return ["scriptUuid"    : scriptUuid]
        case .add(let content, let scriptUuid, let upperReplyUuid):
            return ["content"       : content,
                    "scriptUuid"    : scriptUuid,
                    "upperReplyUuid": upperReplyUuid]
        case .delete(let replyUuid):
            return ["replyUuid"     : replyUuid]
        }
    }
    
    var method: HTTPMethod {
        switch self {
        case .getReplies:
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

