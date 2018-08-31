//
//  FooterView.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 31..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class FooterView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var label: UILabel!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        Bundle.main.loadNibNamed(FooterView.reuseIdentifier, owner: self, options: nil)
        addSubview(self.contentView)
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.label.font = UIFont.nanumRegular(size: 12)
    }
    
}
