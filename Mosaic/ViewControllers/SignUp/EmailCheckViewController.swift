//
//  EmailCheckViewController.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 27..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class EmailCheckViewController: UIViewController {
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var button: UIButton!
    var email: String? = "yurisung@ewhain.net"
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpUI()
    }

    func setUpUI() {
        self.emailLabel.font = UIFont.nanumExtraBold(size: 16)
        
        let text = NSMutableAttributedString(string: email ?? "", attributes:[
            NSAttributedStringKey.foregroundColor: UIColor.Palette.coral,
            NSAttributedStringKey.font: UIFont.nanumRegular(size: 12)])
        text.append(NSMutableAttributedString(string: "으로 인증 메일이\n발송되었습니다. 메일에 있는 ‘인증하기’버튼 혹은\n링크를 클릭해주세요.", attributes:[
            NSAttributedStringKey.foregroundColor: UIColor.Palette.warmGrey,
            NSAttributedStringKey.font: UIFont.nanumRegular(size: 12)]))
        self.contentLabel.attributedText = text
        self.button.titleLabel?.font = UIFont.nanumExtraBold(size: 14)
    }

}
