//
//  UIColor+.swift
//  Mosaic_iOS
//
//  Created by Zedd on 2018. 8. 11..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import UIKit


extension UIColor {
    struct Palette {
        static var robinSEgg: UIColor {
            return UIColor(red: 102.0 / 255.0, green: 227.0 / 255.0, blue: 1.0, alpha: 1.0)
        }
        static var darkGreyBlue: UIColor {
            return UIColor(red: 45.0 / 255.0, green: 50.0 / 255.0, blue: 83.0 / 255.0, alpha: 1.0)
        }
        static var coolBlue: UIColor {
            return UIColor(red: 79.0 / 255.0, green: 156.0 / 255.0, blue: 186.0 / 255.0, alpha: 1.0)
        }
        static var coral: UIColor {
            return UIColor(red: 252.0 / 255.0, green: 84.0 / 255.0, blue: 58.0 / 255.0, alpha: 1.0)
        }
    }
    
    convenience init(hex: String, alpha: CGFloat = 1.0) {
        let hexString: String = hex.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        let scanner = Scanner(string: hexString)
        if (hexString.hasPrefix("#")) {
            scanner.scanLocation = 1
        }
        var color: UInt32 = 0
        scanner.scanHexInt32(&color)
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        self.init(red:red, green:green, blue:blue, alpha:alpha)
    }
    func toHexString() -> String {
        var r:CGFloat = 0
        var g:CGFloat = 0
        var b:CGFloat = 0
        var a:CGFloat = 0
        getRed(&r, green: &g, blue: &b, alpha: &a)
        let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
        return String(format:"#%06x", rgb)
    }
}
