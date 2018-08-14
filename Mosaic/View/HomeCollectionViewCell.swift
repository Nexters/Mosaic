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
        
        self.setupTopView()
        self.setupBottomView()
        
        self.backgroundColor = .white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(hex: "#dddddd").cgColor
        
    }
    
    func setupTopView() {
        self.setupTopLabels()
    }
    
    func setupTopLabels() {
        self.timeLabel.font = UIFont.nanumBold(size: 12)
        self.timeLabel.textColor = ColorPalette.subText
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        paragraphStyle.alignment = .center
        let descriptionAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.nanumRegular(size: 16),
            .foregroundColor: ColorPalette.description,
            .paragraphStyle: paragraphStyle,
            .kern: -2
        ]
        let str = "안녕하세요. IT  연합동아리 넥스터즈 입니다.\n넥스터즈 내 사진 소모임을 함께 하실 디자이너 분들을 모십니다.\n모임은 매주 일요일 오후 강남에서 하고 있습니다. 📷  DSLR, 미러리스.."

        self.descriptionLabel.attributedText = NSAttributedString(string: str, attributes: descriptionAttributes)
    
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
        
        let attribute: [NSAttributedStringKey: Any] = [
            .font: UIFont.nanumBold(size: 10),
            .foregroundColor: ColorPalette.subText
        ]
        
        // FIXME: - 모델에서 가져온 값.
        self.collegeNameLabel.attributedText = NSAttributedString(string: "SOGANG2039", attributes: attribute)
        self.commentLabel.attributedText = NSAttributedString(string: "댓글 24", attributes: attribute)
        self.bookMarkLabel.attributedText = NSAttributedString(string: "스크랩", attributes: attribute)
        
        // logic: 내가 스크랩한 글인지 판단하는 필드 있어야ㅕ함.
    }
    
    
    func configure() {
    
    }
}
