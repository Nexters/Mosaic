//
//  TypeView.swift
//  Mosaic
//
//  Created by Zedd on 2018. 8. 18..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import Foundation
import UIKit
class TypeView: UIView {
    
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var highlightView: UIView!
    class func create(frame: CGRect) -> TypeView {
        let view = UINib(nibName: "TypeView", bundle: nil).instantiate(withOwner: nil, options: nil)[0] as! TypeView
        view.frame = frame
        return view
    }
    
    func setup(fontSize: CGFloat = 16) {
        self.typeLabel.font = UIFont.nanumExtraBold(size: fontSize)
        self.typeLabel.textColor = UIColor(hex: "#474747")
        
    }
    func configure(title: String) {
        self.highlightView.backgroundColor = UIColor(hex: "#ccf6ff")
        self.typeLabel.text = title
    }
}
