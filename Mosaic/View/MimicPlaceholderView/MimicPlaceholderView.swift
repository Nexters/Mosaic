//
//  MimicPlaceholderView.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 22..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class MimicPlaceholderView: UIView {
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var label: UILabel!
    @IBOutlet weak private var blinkingView: UIView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        Bundle.main.loadNibNamed(MimicPlaceholderView.reuseIdentifier, owner: self, options: nil)
        addSubview(self.contentView)
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func blinking() {
        self.blinkingView.alpha = 0.0
        UIView.animate(withDuration: 0.5,
                       delay: 0,
                       options: [.curveLinear, .repeat, .autoreverse],
                       animations: {self.blinkingView.alpha = 1.0},
                       completion: nil)
    }
    
    func setLabel(text: String?, textColor: UIColor = .black, font: UIFont) {
        self.label.text = text
        self.label.textColor = textColor
        self.label.font = font
    }
    
    func setBlinkView(color: UIColor = .black) {
        self.blinkingView.backgroundColor = color
    }
    
}
