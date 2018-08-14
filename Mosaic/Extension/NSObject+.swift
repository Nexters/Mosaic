//
//  NSObject+.swift
//  Mosaic_iOS
//
//  Created by Zedd on 2018. 7. 28..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation

public extension NSObject{
    
    public var classNameToString: String {
        return NSStringFromClass(type(of: self))
    }
    public static var classNameToString: String{
        return NSStringFromClass(self).components(separatedBy: ".").last ?? ""
    }
}
