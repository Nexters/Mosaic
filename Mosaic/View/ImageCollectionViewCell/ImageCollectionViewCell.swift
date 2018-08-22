//
//  ImageCollectionViewCell.swift
//  Mosaic_iOS
//
//  Created by 이광용 on 2018. 7. 30..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var thumbnail:UIImageView!
    @IBOutlet weak var label:UILabel!
    
    var image: UIImage? {
        didSet {
            self.thumbnail.image = image
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setUpUI() { 
        self.thumbnail.layer.cornerRadius = 2
        self.thumbnail.clipsToBounds = true
        self.label.isHidden = true
    }
}
