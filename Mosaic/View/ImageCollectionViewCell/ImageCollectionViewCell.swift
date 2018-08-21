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
    var image: UIImage? {
        didSet {
            self.thumbnail.image = image
        }
    }
}
