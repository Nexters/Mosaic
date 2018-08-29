//
//  SignUpViewController.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 25..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController, TransparentNavBarService, KeyboardControlService {
    //MARK: - PROPERTY
    //MARK: UI
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var termsOfServiceLabel: UILabel!
//    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var imageView:UIImageView!
    @IBOutlet weak var authButton: UIButton!
    @IBOutlet weak var textFieldContainerView: UIView!
    //MARK: CONSTRAINT
    @IBOutlet weak var authButtonBottomConstraint: NSLayoutConstraint!
    //MARK: STORED OR PROPERTY
    var images: [UIImage] = [#imageLiteral(resourceName: "imgBackEwhauniv"), #imageLiteral(resourceName: "imgYonseiuniv"), #imageLiteral(resourceName: "imgBackKoreauniv"), #imageLiteral(resourceName: "imgBackKyungheeuniv"), #imageLiteral(resourceName: "imgBackKoreauniv2") ]
    //MARK: - METHOD
    //MARK: INIT
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavigationBar()
        setUpKeyboard()
        setUpUI()
        setUpImageView()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        self.view.endEditing(true)
    }
    
    func setUpNavigationBar() {
        UIApplication.shared.statusBarStyle = .lightContent
        self.transparentNavigationBar()
        self.navigationController?.navigationBar.tintColor = .white
    }
    
    func setUpKeyboard() {
        self.setKeyboardControl(willShow: { (rect, duration) in
            UIView.animate(withDuration: duration, animations: { [weak self] in
                guard let `self` = self else {return}
                self.authButtonBottomConstraint.constant = rect.height - bottomInset
                self.view.layoutSubviews()
            })
            
        }, willHide: { (rect, duration) in
            UIView.animate(withDuration: duration, animations: { [weak self] in
                guard let `self` = self else {return}
                self.authButtonBottomConstraint.constant = 0
                self.view.layoutSubviews()
            })
        })
    }
    
    func setUpUI() {
        self.emailLabel.font = UIFont.nanumExtraBold(size: 12)
        
        self.textField.font = UIFont.nanumRegular(size: 12)
        self.textField.delegate = self
        
        self.termsOfServiceLabel.isUserInteractionEnabled = true
        self.termsOfServiceLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(termsOfServiceLabelDidTapped(_:))))
        let text = NSMutableAttributedString(string: "이메일 인증 시, 모자이크 ", attributes:[
            NSAttributedStringKey.foregroundColor: UIColor.Palette.greyish,
            NSAttributedStringKey.font: UIFont.nanumBold(size: 11)])
        text.append(NSMutableAttributedString(string: "서비스 약관", attributes:[
            NSAttributedStringKey.foregroundColor: UIColor.Palette.coral,
            NSAttributedStringKey.font: UIFont.nanumBold(size: 11),
            NSAttributedStringKey.underlineStyle: NSUnderlineStyle.styleSingle.rawValue]))
        text.append(NSMutableAttributedString(string: "에 동의하는 것으로 간주합니다.", attributes:[
            NSAttributedStringKey.foregroundColor: UIColor.Palette.greyish,
            NSAttributedStringKey.font: UIFont.nanumBold(size: 11)]))
        self.termsOfServiceLabel.attributedText = text
        
        self.authButton.titleLabel?.font = UIFont.nanumExtraBold(size: 14)
        self.authButton.addTarget(self, action: #selector(authButtonDidTapped), for: .touchUpInside)
        self.isValidEmail(nil)
    }
    
    func setUpImageView() {
        let index = arc4random_uniform(UInt32(self.images.count))
        let image = self.images[Int(index)]
        self.imageView.image = image
        UIView.animate(withDuration: 3) {
            self.imageView.center.x += 50
        }
    }
    
    //MARK: ACTION
    @objc
    func termsOfServiceLabelDidTapped(_ gestureRecognizer: UITapGestureRecognizer) {
        self.view.endEditing(true)
        let viewController = AuthViewController.create(storyboard: "SignUp")
        viewController.modalPresentationStyle = .overCurrentContext
        self.present(viewController, animated: true, completion: nil)
    }
    
    @objc
    func authButtonDidTapped() {
        if self.authButton.isEnabled {
            guard let email = self.textField.text else {return}
            APIRouter.shared.request(logIn: APIRouter.LogIn.email(value: email)) { (code: Int?, value: User?) in
                print(code)
                
            }
            let viewcontroller = EmailCheckViewController.create(storyboard: "SignUp")
            self.navigationController?.pushViewController(viewcontroller, animated: true)
        }
    }
    
    func isValidEmail(_ text: String?) {
        guard let text = text else {
            enableAuthButton(false)
            return
        }
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        enableAuthButton(emailTest.evaluate(with: text))
    }
    
    func enableAuthButton(_ value: Bool) {
        self.authButton.isEnabled = value
        self.authButton.backgroundColor = value ? UIColor.Palette.coral : UIColor.Palette.silver
    }
}

extension SignUpViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else {
            isValidEmail(nil)
            return true }
        let prospectiveText = (text as NSString).replacingCharacters(in: range, with: string)
        isValidEmail(prospectiveText)
        let length = prospectiveText.count
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        authButtonDidTapped()
        return true
    }
}
