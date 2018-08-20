//
//  UIFont+.swift
//  Mosaic
//
//  Created by Zedd on 2018. 8. 14..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import UIKit
extension UIFont {
    static func nanumBold(size: CGFloat) -> UIFont {
        return UIFont(name: "NanumSquareB", size: size)!
    }
    static func nanumLight(size: CGFloat) -> UIFont {
        return UIFont(name: "NanumSquareL", size: size)!
    }
    static func nanumRegular(size: CGFloat) -> UIFont {
        return UIFont(name: "NanumSquareR", size: size)!
    }
    static func nanumExtraBold(size: CGFloat) -> UIFont {
        return UIFont(name: "NanumSquareEB", size: size)!
    }
}
