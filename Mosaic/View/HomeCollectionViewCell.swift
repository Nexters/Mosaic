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
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        paragraphStyle.alignment = .center
        let descriptionAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.nanumRegular(size: 16),
            .foregroundColor: ColorPalette.description,
            .paragraphStyle: paragraphStyle,
            .kern: -1
        ]
        
        let str = "올해 하반기에 열리는 전국 비보이\n댄스대회에 함께 할 팀원을 구합니다. 올해로\n4회째 수상하고 있습니다. 체계적인 연습과\n끈끈한 팀워크로 대학 동안 즐거운 추억을\n만드실 여러분들의 연락 기다립니다.\n올해도 수상 가즈아 🔥"

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
