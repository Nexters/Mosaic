//
//  MyCommentTableViewCell.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 23..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class CommentTableViewCell: UITableViewCell {
    @IBOutlet weak var universityLogoImageView: UIImageView!
    @IBOutlet weak var universityLabel: UILabel!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var myMimicLableButton: UIButton!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var replyButton: ParameterButton!
    @IBOutlet weak var thumbnailHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var thumbnailTopMarginConstraint: NSLayoutConstraint!
    
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
                self.self.thumbnailTopMarginConstraint.constant = 12
                self.thumbnail.kf.setImage(with: URL(string: imageURL))
            }
            self.contentLabel.text = reply.content
            self.timeLabel.text = Date().text(reply.createdAt)
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
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
        self.thumbnail.image = nil
        self.thumbnail.kf.indicatorType = .activity
        
        self.replyButton.titleLabel?.font = UIFont.nanumBold(size: 10)
        self.replyButton.layer.borderWidth = 1
        self.replyButton.layer.borderColor = UIColor.Palette.lgithGreyWhite.cgColor
        self.replyButton.layer.cornerRadius = 2
        self.replyButton.clipsToBounds = true
        
        self.thumbnailHeightConstraint.constant = 0
        self.thumbnailTopMarginConstraint.constant = 0
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        setUpUI()
    }
    
}

//PARAMETER BUTTON
class ParameterButton: UIButton {
    var params: Dictionary<String, Any> = [:]
}
