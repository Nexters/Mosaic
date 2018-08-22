//
//  CategoryView.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 23..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

@IBDesignable
class CategoryView: UIView {
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var highlightView: UIView!
    @IBOutlet weak private var highlightViewHeightConstrinat: NSLayoutConstraint!
    @IBInspectable
    var highlighHeight: CGFloat = 9.0
    @IBInspectable
    var highlightColor: UIColor? = UIColor.Palette.lightSkyBlue
//    @IBInspectable
//    var text: String?
    @IBInspectable
    var textColor: UIColor? = .black
    lazy
    var font: UIFont = self.label.font
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
    
    func setup(fontSize: CGFloat = 16) {
        self.label.font = UIFont.nanumExtraBold(size: fontSize)
        self.label.textColor = UIColor(hex: "#474747")
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.highlightView.backgroundColor = self.highlightColor
        if let category = self.category {
            self.label.text = category.title + category.title
        }
        self.label.font = self.font
        self.label.textColor = self.textColor
        self.highlightViewHeightConstrinat.constant = self.highlighHeight
    }
    
    func setCategory(_ category: Category) {
        
    }
}