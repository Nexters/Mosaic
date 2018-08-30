//
//  CategoryView.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 23..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class CategoryView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak var highlightView: UIView!
    @IBOutlet weak private var highlightViewHeightConstrinat: NSLayoutConstraint!
    var highlighHeight: CGFloat = 9.0
    var highlightColor: UIColor? = UIColor.Palette.lightSkyBlue
    var textColor: UIColor? = UIColor(hex: "#474747")
    var category: Category?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    private func setUpView() {
        Bundle.main.loadNibNamed(CategoryView.reuseIdentifier, owner: self, options: nil)
        addSubview(self.contentView)
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]

        self.highlightView.backgroundColor = self.highlightColor
    }
    
    func setUp(font: UIFont = UIFont.nanumExtraBold(size: 16)) {
        self.label.font = font
        
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.highlightView.backgroundColor = self.highlightColor
        if let category = self.category {
            self.label.text = category.title + category.emoji
        }
        self.label.textColor = self.textColor
        self.highlightViewHeightConstrinat.constant = self.highlighHeight
    }

}
