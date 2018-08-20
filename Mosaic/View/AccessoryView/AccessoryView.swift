//
//  AccessoryView.swift
//  Mosaic_iOS
//
//  Created by 이광용 on 2018. 7. 25..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class AccessoryView: UIView {
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var imageButton: UIButton!
    
    static var height: CGFloat = 44.0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    
    private func setUpView() {
        Bundle.main.loadNibNamed(AccessoryView.reuseIdentifier, owner: self, options: nil)
        addSubview(self.contentView)
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
    func addTarget(_ target: Any?, selector: Selector) {
        self.imageButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    
    func setContentViewBackgroundColor(_ color: UIColor?) {
        self.contentView.backgroundColor = color
    }
}
