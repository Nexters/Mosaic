//
//  CommentAccessoryView.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 22..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class CommentAccessoryView: UIView {

    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    static var normalHeight: CGFloat = 52
    static var changedHeight: CGFloat = 112
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thumbnail.layer.cornerRadius = 2
        self.thumbnail.clipsToBounds = true
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    private func setUpView() {
        Bundle.main.loadNibNamed(CommentAccessoryView.reuseIdentifier, owner: self, options: nil)
        addSubview(self.contentView)
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.contentView.layer.borderWidth = 1
        self.contentView.layer.borderColor = UIColor.Palette.grayWhite.cgColor
        
        self.thumbnail.alpha = 0.0
        self.deleteButton.alpha = 0.0
    }
    
    func showImageView(_ value: Bool) {
        
        UIView.animate(withDuration: 0.5) {
            self.thumbnail.alpha = value ? 1.0 : 0.0
            self.deleteButton.alpha = value ? 1.0 : 0.0
        }
    }

}
