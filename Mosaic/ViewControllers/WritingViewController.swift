//
//  WritingViewController.swift
//  Mosaic_iOS
//
//  Created by 이광용 on 2018. 7. 20..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

//https://stackoverflow.com/questions/46282987/iphone-x-how-to-handle-view-controller-inputaccessoryview
//http://ahbou.org/post/165762292157/iphone-x-inputaccessoryview-fix
//https://medium.com/code-brew-com/dynamic-height-of-accessory-view-in-ios-bf0c2efe6da8

//https://stackoverflow.com/questions/13006464/how-to-fix-the-issue-command-bin-sh-failed-with-exit-code-1-in-iphone
var bottomInset: CGFloat {
    //use in viewDidLoad or viewDidLayoutSubviews
    if #available(iOS 11.0, *) {
        if let inset = UIApplication.shared.keyWindow?.safeAreaInsets.bottom {
            return inset
        }
    }
    return 0
}

class WritingViewController: UIViewController, KeyboardControlService, TransparentNavBarService {
    
    //MARK: - PROPERTY
    //MARK: UI
    @IBOutlet weak var textView: VerticallyCenteredTextView!
    @IBOutlet weak var accessoryView: AccessoryView!
    @IBOutlet weak var mimicPlaceholderView: MimicPlaceholderView!
    var navigationBarTitleButton: UIButton?
    var saveButton: UIBarButtonItem?
    //MARK: CONSTRAINT
    @IBOutlet weak var accessoryViewHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var accessoryViewBottomConstraint: NSLayoutConstraint!
    //MARK: STORED OR COMPUTED
    var images: [UIImage] = [] {
        didSet {
//            showImageCollectionView(!images.isEmpty)
        }
    }
    var selectedCategory: Category?
    //MARK: - METHOD
    //MARK: INITIALIZE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpKeyboard()
        setupNavigationBar()
        setUpAccessoryView()
        setUpTextView()
        setUpMimicPlaceHolderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAccessoryViewContraint(height: AccessoryView.height + bottomInset, bottom: 0)
        self.textView.becomeFirstResponder()
        updateNavigationBarTitle(category: self.selectedCategory)
    }

    
    deinit {
        self.removeKeyboardControl()
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    //MARK: SET UP
    func setUp() {
        self.view.backgroundColor = UIColor.Palette.robinSEgg
        self.images.removeAll()
    }
    
    //MARK: SET UP KEYBOARD
    func setUpKeyboard() {
        self.setKeyboardControl(willShow: { [weak self] (rect, duration) in
            guard let `self` = self else {return}
            UIView.animate(withDuration: duration, animations: {
                self.setAccessoryViewContraint(height: AccessoryView.height, bottom: rect.height)
            })
            }, willHide: { [weak self] (rect, duration) in
                guard let `self` = self else {return}
                UIView.animate(withDuration: duration, animations: {
                    self.setAccessoryViewContraint(height: AccessoryView.height + bottomInset, bottom: 0)
                })
        })
    }
    
    //MARK: SET UP NAVIGATIONBAR
    func setupNavigationBar() {
        self.transparentNavigationBar()
        self.navigationBarTitleButton = UIButton(type: .custom)
        guard let button = self.navigationBarTitleButton else {return}
        button.setTitle("카테고리 선택", for: .normal)
        button.titleLabel?.shadowOffset = CGSize(width: 1, height: 1)
        button.setTitleShadowColor(.gray, for: .normal)
        button.setImage(UIImage(named: "icWritingFilterDown"), for: .normal)
        button.semanticContentAttribute =
            (UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft)
        button.addTarget(self, action: #selector(categoryButtonDidTap), for: .touchUpInside)
        button.titleLabel?.font = UIFont.nanumExtraBold(size: 18)
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = button
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icSearchClose"), style: .plain, target: self, action: #selector(closeButtonDidTap))
        
        self.saveButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButtonDidTap))
        guard let saveButton = self.saveButton else {return}
        saveButton.tintColor = UIColor.Palette.darkGreyBlue
        
        saveButton.setTitleTextAttributes([NSAttributedStringKey.font: UIFont.nanumExtraBold(size: 14.0)], for: .normal)

        self.navigationItem.rightBarButtonItem = self.saveButton
    }
    
    //MARK: SET UP ACCESSORYVIEW
    func setUpAccessoryView() {
        ImagePickerController.shared.delegate = self
        self.accessoryView.setUp(.writing, delegate: self)
        self.accessoryView.addTarget(self, selector: #selector(showImagePicker))
    }
    
    func setAccessoryViewContraint(height: CGFloat, bottom: CGFloat) {
        self.accessoryViewHeightConstaint.constant = height
        self.accessoryViewBottomConstraint.constant =  bottom
        self.view.layoutIfNeeded()
    }
    
    //MARK: SET UP TEXTVIEW
    func setUpTextView() {
        self.textView.delegate = self
        self.textView.isHidden = true
        self.textView.font = UIFont.nanumRegular(size: 16)
        self.textView.tintColor = UIColor.Palette.coral
    }
    
    //MARK: SET UP MIMICPLACEHOLDERVIEW
    func setUpMimicPlaceHolderView() {
        self.mimicPlaceholderView.isHidden = false
        self.mimicPlaceholderView.backgroundColor = .clear
        self.mimicPlaceholderView.setBlinkView(color: self.textView.tintColor)
        self.mimicPlaceholderView.setLabel(text: "내용을 적어보세요.", font: UIFont.nanumRegular(size: 16))
    }
    
    //MARK: ACTION
    @objc
    func showImagePicker() {
        showImagePickerController()
    }
    
    @objc
    func closeButtonDidTap() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func saveButtonDidTap() {
        
    }
    
    @objc
    func categoryButtonDidTap() {
        guard let viewController = WritingFilterViewController.create(storyboard: "Filter") as? WritingFilterViewController else {return}
        viewController.previousViewController = self
        let navigation = UINavigationController(rootViewController: viewController)
        self.present(navigation, animated: true, completion: nil)
    }
    
    func imagesApped(image: UIImage) {
        self.images.append(image)
        self.accessoryView.reloadCollectionView()
    }
    
    func updateNavigationBarTitle(category: Category?) {
        guard let button = self.navigationBarTitleButton else {return}
        if let category = category {
            button.setTitle(category.title + category.emoji, for: .normal)
        } else {
            button.setTitle("카테고리 선택", for: .normal)
        }
    }
}

//MARK: - EXTENSION
//MARK: IMAGEPICKERCONTROLLERPRESENTABLE
extension WritingViewController: ImagePickerControllerPresentable {
    func imagePickerController(_ picker: UIImagePickerController, selectedImage image: UIImage) {
        imagesApped(image: image)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
    }
}

//MARK: UICOLLECTIONVIEWDELEGATE, UICOLLECTIONVIEWDATASOURCE
extension WritingViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setUpUI()
        cell.image = images[indexPath.row]
        cell.transform = CGAffineTransform(scaleX: -1, y: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.images.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 33, height: 33)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

//MARK: UITEXTVIEWDELEGATE
extension WritingViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let prospectiveText = (textView.text as NSString).replacingCharacters(in: range, with: text)
        let length = prospectiveText.count
        self.textView.isHidden = !(0 < length)
        self.mimicPlaceholderView.isHidden = (0 < length)
        return true
    }
}

//MARK: ACCESSORYVIEWDELEGATE
extension WritingViewController: AccessoryViewDelegate {
    func accessoryView(_ view: AccessoryView) {
        
    }
}
