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

    var str: String? {
        didSet {
            self.contentLabel.text = str
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
        
        self.thumbnail.clipsToBounds = true
        self.thumbnail.layer.cornerRadius = 5
        
        self.replyButton.titleLabel?.font = UIFont.nanumBold(size: 10)
        self.replyButton.layer.borderWidth = 1
        self.replyButton.layer.borderColor = UIColor.Palette.lgithGreyWhite.cgColor
        self.replyButton.layer.cornerRadius = 2
        self.replyButton.clipsToBounds = true
    }
    
}

//PARAMETER BUTTON
class ParameterButton: UIButton {
    var params: Dictionary<String, Any> = [:]
}
