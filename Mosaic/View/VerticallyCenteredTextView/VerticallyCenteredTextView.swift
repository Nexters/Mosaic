//
//  VerticallyCenteredView.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 22..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class VerticallyCenteredTextView: UITextView {
    override var contentSize: CGSize {
        didSet {
            verticallyCenter()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        verticallyCenter()
    }
    func verticallyCenter() {
        var topCorrection = (self.bounds.size.height - self.contentSize.height * self.zoomScale) / 2.0
        topCorrection = max(0, topCorrection)
        self.contentInset = UIEdgeInsets(top: topCorrection, left: 0, bottom: 0, right: 0)
    }
}
