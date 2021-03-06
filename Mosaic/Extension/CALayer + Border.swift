//
//  Layer + Border.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 24..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

extension CALayer {
    func addBorder(_ arr_edge: [UIRectEdge], color: UIColor, width: CGFloat) {
        let name = "BorderLayer"
        if let sublayers = self.sublayers,
            !sublayers.filter({$0.name == name}).isEmpty {
            return
        }
        for edge in arr_edge {
            let border = CALayer()
            border.name = name
            switch edge {
            case UIRectEdge.top:
                border.frame = CGRect.init(x: 0, y: 0, width: frame.width, height: width)
                break
            case UIRectEdge.bottom:
                border.frame = CGRect.init(x: 0, y: frame.height - width, width: frame.width, height: width)
                break
            case UIRectEdge.left:
                border.frame = CGRect.init(x: 0, y: 0, width: width, height: frame.height)
                break
            case UIRectEdge.right:
                border.frame = CGRect.init(x: frame.width - width, y: 0, width: width, height: frame.height)
                break
            default:
                break
            }
            border.backgroundColor = color.cgColor;
            self.addSublayer(border)
        }
    }
}


