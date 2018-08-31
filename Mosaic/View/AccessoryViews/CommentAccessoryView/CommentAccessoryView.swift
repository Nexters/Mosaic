//
//  CommentAccessoryView.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 22..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

struct UpperReply {
    var uuid: String = ""
    var name: String = ""
}

class CommentAccessoryView: UIView {

    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak var imageButton: UIButton!
    @IBOutlet weak var textField: ObserveBackTextField!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var thumbnail: UIImageView!
    @IBOutlet weak var downloadLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var nicknameLabel: UILabel!
    
    static var normalHeight: CGFloat = 52
    static var changedHeight: CGFloat = 112
    var upperReply = UpperReply()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.thumbnail.layer.cornerRadius = 2
        self.thumbnail.clipsToBounds = true
        
        self.textField.font = UIFont.nanumRegular(size: 12)
        self.textField.tintColor = UIColor.Palette.coral
        self.nicknameLabel.font = UIFont.nanumRegular(size: 12)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.contentView.layer.addBorder([.top], color: UIColor.Palette.grayWhite, width: 1)
    }
    
    private func setUpView() {
        Bundle.main.loadNibNamed(CommentAccessoryView.reuseIdentifier, owner: self, options: nil)
        addSubview(self.contentView)
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.thumbnail.alpha = 0.0
        self.downloadLabel.isHidden = true
        self.deleteButton.alpha = 0.0
        self.nicknameLabel.text = nil
        
        self.textField.delegate = self
        self.textField.addTarget(self, action: #selector(textFieldDidChanged(_:)), for: .editingChanged)
        self.textField.observeBackDelegate = self
        self.textField.autocorrectionType = .no
        
        enableSendButton(false)
    }
    
    func showImageView(_ image: UIImage?) {
        self.thumbnail.image = image
        let value = (image != nil)
        self.thumbnail.alpha = value ? 1.0 : 0.0
        self.deleteButton.alpha = value ? 1.0 : 0.0
    }
    
    func setNicknameLabel(_ upper: UpperReply) {
        self.upperReply = upper
        self.nicknameLabel.text = self.upperReply.name
    }
    
    func setTextField(_ text: String?) {
        self.textField.text = text 
    }
    
    func imageButtonAddTarget(_ target: Any?, action: Selector) {
        self.imageButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func sendButtonAddTarget(_ target: Any?, action: Selector) {
        self.sendButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func deleteButtonAddTarget(_ target: Any?, action: Selector) {
        self.deleteButton.addTarget(target, action: action, for: .touchUpInside)
    }
    
    func reset() {
        setNicknameLabel(UpperReply())
        self.textField.text = ""
        enableSendButton(false)
    }
    
    func enableSendButton(_ value: Bool) {
        switch value {
        case true:
            self.sendButton.setEnable(true, color: UIColor.Palette.coral)
        case false:
            self.sendButton.setEnable(false, color: UIColor.Palette.silver)
        }
    }
}

extension CommentAccessoryView: ObserveBackTextFieldDelegate, UITextFieldDelegate {
    func textFieldDidDelete(_ textField: ObserveBackTextField, previousText: String?) {
        guard let text = previousText else {
            self.setNicknameLabel(UpperReply())
            return
        }
        if text.isEmpty {
            self.setNicknameLabel(UpperReply())
        }
    }
    
//    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
//        guard let text = textField.text else {return true}
//        let prospectiveText = (text as NSString).replacingCharacters(in: range, with: string)
//        let length = prospectiveText.count
//
//        return true
//    }
    
    @objc
    func textFieldDidChanged(_ textField: UITextField) {
        guard let text = textField.text else {return}
        enableSendButton(!text.isNilOrEmpty())
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if self.sendButton.isEnabled {
            self.sendButton.sendActions(for: .touchUpInside)
        }
        return true
    }
}

//MARK: - OBSERVEBACKTEXTFIELD
protocol ObserveBackTextFieldDelegate  {
    func textFieldDidDelete(_ textField: ObserveBackTextField, previousText: String?)
}

class ObserveBackTextField: UITextField {
    var observeBackDelegate: ObserveBackTextFieldDelegate?
    
    override func deleteBackward() {
        self.observeBackDelegate?.textFieldDidDelete(self, previousText: self.text)
        super.deleteBackward()
    }
}
