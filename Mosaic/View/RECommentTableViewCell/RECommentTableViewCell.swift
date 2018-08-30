//
//  RECommentTableViewCell.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 23..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class RECommentTableViewCell: UITableViewCell {
    
    @IBOutlet weak var universityLogoImageView: UIImageView!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var myMimicLableButton: UIButton!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var thumbnailHeightConstraint: NSLayoutConstraint!
    
    var reply: Reply? {
        didSet {
            guard let reply = reply else {return}
            if let universityLogoURL = reply.writer?.university?.imageUrl {
                self.universityLogoImageView.kf.setImage(with: URL(string: universityLogoURL))
            }
            self.universityLabel.text = reply.writer?.university?.name
            self.nicknameLabel.text = reply.writer?.nickName
            if let imageURL = reply.imgUrl, !imageURL.isEmpty {
                self.thumbnailHeightConstraint.constant = 110
                self.thumbnail.kf.setImage(with: URL(string: imageURL))
            }
            
            let content = NSMutableAttributedString(string: reply.upperReplyNick,
                                                    attributes: [.font : UIFont.nanumRegular(size: 12),
                                                                 .foregroundColor : UIColor.Palette.coral])
            content.append(NSMutableAttributedString(string: reply.content,
                                                     attributes: [.font : UIFont.nanumRegular(size: 12),
                                                                  .foregroundColor : UIColor.Palette.greyishBrown]))
            self.contentLabel.attributedText = content
            
            self.timeLabel.text = Date().text(reply.createdAt)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setUpUI()
    }
    
    func setUpUI() {
        self.universityLogoImageView.clipsToBounds = true
        self.universityLabel.font = UIFont.nanumBold(size: 12)
        
        self.nicknameLabel.font = UIFont.nanumRegular(size: 12)
        
        self.contentLabel.font = UIFont.nanumRegular(size: 12)
        
        self.timeLabel.font = UIFont.nanumRegular(size: 10)
        
        self.myMimicLableButton.titleLabel?.font = UIFont.nanumBold(size: 9)
        self.myMimicLableButton.clipsToBounds = true
        self.myMimicLableButton.layer.cornerRadius = 2
        self.myMimicLableButton.isHidden = true
        
        self.thumbnail.clipsToBounds = true
        self.thumbnail.layer.cornerRadius = 5
        
        self.thumbnailHeightConstraint.constant = 0
    }

    
}
