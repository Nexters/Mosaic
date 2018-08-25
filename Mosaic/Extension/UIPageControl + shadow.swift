//
//  File.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 25..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

extension UIPageControl {
    func addShadow(shadowColor: UIColor, shadowOffset: CGSize, shadowOpacity: Float) {
        for (index, view) in self.subviews.enumerated() {
            view.layer.shadowColor = shadowColor.cgColor
            view.layer.shadowOffset = shadowOffset
            view.layer.shadowOpacity = shadowOpacity
        }
    }
}
