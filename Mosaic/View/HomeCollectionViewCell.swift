//
//  HomeCollectionViewCell.swift
//
//
//  Created by Zedd on 2018. 8. 8..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit
extension UIFont {
    
}

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var collegeContainerView: UIView!
    @IBOutlet weak var collegeImageView: UIImageView!
    @IBOutlet weak var collegeNameLabel: UILabel!
    
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var bookMarkContainerView: UIView!
    @IBOutlet weak var bookMarkImageView: UIImageView!
    @IBOutlet weak var bookMarkLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.collegeContainerView.backgroundColor = UIColor(hex: "#2d3253")
        
        self.bookMarkContainerView.backgroundColor = UIColor(hex: "#ff573d")
        
       self.collegeContainerView.layer.cornerRadius = 2
        self.bookMarkContainerView.layer.cornerRadius = 2
        
    }
    
    func configure() {
        self.backgroundColor = .white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(hex: "#dddddd").cgColor
    }
}
