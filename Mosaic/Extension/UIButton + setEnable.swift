//
//  UIButton + setEnable.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 30..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import UIKit

extension UIButton {
    func setEnable(_ value: Bool, color: UIColor) {
        self.isEnabled = value
        self.setTitleColor(color, for: .normal)
        let image = self.imageView?.image?.withRenderingMode(.alwaysTemplate)
        self.setImage(image, for: .normal)
        self.tintColor = color
    }
}

extension UIBarButtonItem {
    func setEnable(_ value: Bool, color: UIColor) {
        self.isEnabled = value
        let image = self.image?.withRenderingMode(.alwaysTemplate)
        self.image = image
        self.tintColor = color
    }
}
