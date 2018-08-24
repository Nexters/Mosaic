//
//  PagingImageCollectionView.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 24..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class PagingImageCollectionView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collctionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        Bundle.main.loadNibNamed(PagingImageCollectionView.reuseIdentifier, owner: self, options: nil)
        addSubview(self.contentView)
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    }
    
}
