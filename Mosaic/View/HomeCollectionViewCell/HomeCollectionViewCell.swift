//
//  HomeCollectionViewCell.swift
//
//
//  Created by Zedd on 2018. 8. 8..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit
extension ColorPalette {
    static let collegeContainer = UIColor(hex: "#2d3253")
    static let bookmarkContainer = UIColor(hex: "#ff573d")
    static let subText = UIColor(hex: "#abafb4")
    static let description = UIColor(hex: "#474747")
}

class HomeCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var collegeContainerView: UIView!
    @IBOutlet weak var collegeImageView: UIImageView!
    @IBOutlet weak var collegeNameLabel: UILabel!
    
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var bookMarkContainerView: UIView!
    @IBOutlet weak var bookMarkImageView: UIImageView!
    @IBOutlet weak var bookMarkLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupTopView()
        self.setupBottomView()
        
        self.backgroundColor = .white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(hex: "#dddddd").cgColor
        
        self.layer.cornerRadius = 2
        self.lineView.backgroundColor = UIColor(hex: "#dbdbdb")
    }
    
    func setupTopView() {
        self.setupTopLabels()
        let typeView = TypeView.create(frame: self.typeView.bounds)
        typeView.setup()
        typeView.configure(title: "공모전🏆")
        self.typeView.addSubview(typeView)
        
    }
    
    func setupTopLabels() {
        self.timeLabel.font = UIFont.nanumBold(size: 12)
        self.timeLabel.textColor = ColorPalette.subText
        
    }
    
    func setupBottomView() {
        self.setupContainerViews()
        self.setupBottomeLabels()
    }
    
    func setupContainerViews() {
        self.collegeContainerView.backgroundColor = ColorPalette.collegeContainer
        self.bookMarkContainerView.backgroundColor = ColorPalette.bookmarkContainer
        
        self.collegeContainerView.layer.cornerRadius = 2
        self.bookMarkContainerView.layer.cornerRadius = 2
    }
    
    func setupBottomeLabels() {
      
        
        // FIXME: - 모델에서 가져온 값.
        
        // logic: 내가 스크랩한 글인지 판단하는 필드 있어야ㅕ함.
    }
    
    
    func configure(article: Article?) {
        guard let article = article else { return }
        
        let attribute: [NSAttributedStringKey: Any] = [
            .font: UIFont.nanumBold(size: 10),
            .foregroundColor: ColorPalette.subText
        ]
        self.collegeNameLabel.attributedText = NSAttributedString(string: article.writer?.nickName ?? "", attributes: attribute)
        self.commentLabel.attributedText = NSAttributedString(string: "댓글 \(article.replies)", attributes: attribute)
        self.bookMarkLabel.attributedText = NSAttributedString(string: "스크랩", attributes: attribute)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        paragraphStyle.alignment = .center
        let descriptionAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.nanumRegular(size: 16),
            .foregroundColor: ColorPalette.description,
            .paragraphStyle: paragraphStyle,
            .kern: -1
        ]
        
        self.descriptionLabel.attributedText = NSAttributedString(string: article.content ?? "", attributes: descriptionAttributes)
        
        if article.imageUrls?.isEmpty == true {
            
        } else {
            
        }
    }
}
