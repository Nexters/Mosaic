//
//  WritingViewController.swift
//  Mosaic_iOS
//
//  Created by 이광용 on 2018. 7. 20..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit
import TLPhotoPicker
import Photos

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
    var navigationBarTitleButton: UIButton = UIButton(type: .custom)
    var saveButton: UIButton = UIButton(type: .custom)
    //MARK: CONSTRAINT
    @IBOutlet weak var accessoryViewBottomConstraint: NSLayoutConstraint!
    //MARK: STORED OR COMPUTED
    var selectedCategory: Categories?
    var selectedAssets = [TLPHAsset]()
    
    //MARK: - METHOD
    //MARK: INITIALIZE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpKeyboard()
        setUpNavigationBar()
        setUpAccessoryView()
        setUpTextView()
        setUpMimicPlaceHolderView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.textView.becomeFirstResponder()
        updateNavigationBarTitle(category: self.selectedCategory)
        self.mimicPlaceholderView.blinking()
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
    }
    
    //MARK: SET UP KEYBOARD
    func setUpKeyboard() {
        self.setKeyboardControl(willShow: { [weak self] (rect, duration) in
            guard let `self` = self else {return}
            UIView.animate(withDuration: duration, animations: {
                self.accessoryViewBottomConstraint.constant =  rect.height - bottomInset
                self.view.layoutIfNeeded()
            })
            }, willHide: { [weak self] (rect, duration) in
                guard let `self` = self else {return}
                UIView.animate(withDuration: duration, animations: {
                    self.accessoryViewBottomConstraint.constant =  0
                    self.view.layoutIfNeeded()
                })
        })
    }
    
    //MARK: SET UP NAVIGATIONBAR
    func setUpNavigationBar() {
        self.transparentNavigationBar(shadowImage: #imageLiteral(resourceName: "icWritingShadow"))
        
        self.navigationBarTitleButton.setTitle("카테고리 선택", for: .normal)
        self.navigationBarTitleButton.titleLabel?.shadowOffset = CGSize(width: 1, height: 1)
        self.navigationBarTitleButton.setTitleShadowColor(.gray, for: .normal)
        self.navigationBarTitleButton.setImage(UIImage(named: "icWritingFilterDown"), for: .normal)
        self.navigationBarTitleButton.semanticContentAttribute =
            (UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft)
        self.navigationBarTitleButton.addTarget(self, action: #selector(categoryButtonDidTap), for: .touchUpInside)
        self.navigationBarTitleButton.titleLabel?.font = UIFont.nanumExtraBold(size: 18)
        self.navigationBarTitleButton.titleLabel?.adjustsFontSizeToFitWidth = true
        self.navigationItem.titleView = self.navigationBarTitleButton
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icSearchClose"), style: .plain, target: self, action: #selector(closeButtonDidTap))
        
        self.saveButton.addTarget(self, action: #selector(saveButtonDidTap), for: .touchUpInside)
        self.saveButton.setTitle("저장", for: .normal)
        self.saveButton.titleLabel?.font = UIFont.nanumExtraBold(size: 14.0)
        self.saveButton.setTitleColor(UIColor.Palette.coolBlue, for: .normal)
        self.navigationItem.setRightBarButton(UIBarButtonItem(customView: self.saveButton), animated: true)
        self.saveButton.setEnable(false, color: UIColor.Palette.coolBlue)
    }
    
    //MARK: SET UP ACCESSORYVIEW
    func setUpAccessoryView() {
        self.accessoryView.addTarget(self, selector: #selector(showImagePicker))
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
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.maxSelectedAssets = 5
        configure.mediaType = PHAssetMediaType.image
        configure.cancelTitle = "취소"
        configure.doneTitle = "완료"
        
        let photoPicker = TLPhotosPickerViewController()
        photoPicker.delegate = self
        photoPicker.configure = configure
        photoPicker.selectedAssets = self.selectedAssets
        photoPicker.didExceedMaximumNumberOfSelection = { (picker) in
            UIAlertController.showMessage("선택가능한 숫자를 초과했습니다.")
        }
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    @objc
    func closeButtonDidTap() {
        self.view.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func saveButtonDidTap() {
        guard let uuid = self.selectedCategory?.uuid else {return}
        guard let text = self.textView.text else {return}
        guard let images = self.accessoryView.selectedImages as? [UIImage] else {return}
        
        APIRouter.shared.upload(ArticleService.write(uuid: uuid,
                                                     content: text),
                                imageKey: "imgUrls",
                                images: images) { (code: Int?, article: Article?) in
                                    guard let code = code else {return}
                                    switch code {
                                    case 200:
                                        self.dismiss(animated: true, completion: nil)
                                    default:
                                        break
                                    }
        }
    }
    
    @objc
    func categoryButtonDidTap() {
        guard let viewController = WritingFilterViewController.create(storyboard: "Filter") as? WritingFilterViewController else {return}
        viewController.previousViewController = self
        let navigation = UINavigationController(rootViewController: viewController)
        self.present(navigation, animated: true, completion: nil)
    }
    
    func updateNavigationBarTitle(category: Categories?) {
        if let category = category {
            navigationBarTitleButton.setTitle(category.name + category.emoji, for: .normal)
        } else {
            navigationBarTitleButton.setTitle("카테고리 선택", for: .normal)
        }
    }
}

//MARK: - EXTENSION
//MARK: TLPhotosPickerViewControllerDelegate
extension WritingViewController: TLPhotosPickerViewControllerDelegate {
    func handleNoAlbumPermissions(picker: TLPhotosPickerViewController) {
        picker.dismiss(animated: true) {
            let alert = UIAlertController(title: "", message: "Denied albums permissions granted", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func handleNoCameraPermissions(picker: TLPhotosPickerViewController) {
        let alert = UIAlertController(title: "", message: "Denied camera permissions granted", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        picker.present(alert, animated: true, completion: nil)
    }
    
    func dismissPhotoPicker(withTLPHAssets: [TLPHAsset]) {
        self.selectedAssets = withTLPHAssets
        self.accessoryView.selectedImages = withTLPHAssets.map { (asset) -> UIImage? in
            return asset.fullResolutionImage
        }
        self.accessoryView.reloadCollectionView()
    }
}

//MARK: UITEXTVIEWDELEGATE
extension WritingViewController: UITextViewDelegate {
//    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
//        let prospectiveText = (textView.text as NSString).replacingCharacters(in: range, with: text)
//        let length = prospectiveText.count
//        enableSaveButton(length)
//
//        return true
//    }
//
    func textViewDidChange(_ textView: UITextView) {
        let isEmpty = textView.text.isNilOrEmpty()
        self.textView.isHidden = isEmpty
        self.mimicPlaceholderView.isHidden = !isEmpty
        if !isEmpty && self.selectedCategory != nil {
            self.saveButton.setEnable(true, color: .white)
        } else {
            self.saveButton.setEnable(false, color: UIColor.Palette.coolBlue)
        }
    }
}
