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
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var accessoryView: AccessoryView!
    var saveButton: UIBarButtonItem!
    //MARK: CONSTRAINT
    @IBOutlet weak var imageCollectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var accessoryViewHeightConstaint: NSLayoutConstraint!
    @IBOutlet weak var accessoryViewBottomConstraint: NSLayoutConstraint!
    //MARK: STORED OR COMPUTED
    var images: [UIImage] = [] {
        didSet {
//            showImageCollectionView(!images.isEmpty)
        }
    }
    var selectedCategory: [Category] = []
    //MARK: - METHOD
    //MARK: INITIALIZE
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        setUpKeyboard()
        setupNavigationBar()
        setUpAccessoryView()
        setUpImageCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setAccessoryViewContraint(height: AccessoryView.height + bottomInset, bottom: 0)
        self.textView.becomeFirstResponder()
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
        let button = UIButton(type: .custom)
        button.setTitle("카테고리 선택", for: .normal)
        button.titleLabel?.shadowOffset = CGSize(width: 1, height: 1)
        button.setTitleShadowColor(.gray, for: .normal)
        button.setImage(UIImage(named: "icWritingFilterDown"), for: .normal)
        button.semanticContentAttribute =
            (UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft)
        button.addTarget(self, action: #selector(categoryButtonDidTap), for: .touchUpInside)
        self.navigationItem.titleView = button
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icSearchClose"), style: .plain, target: self, action: #selector(closeButtonDidTap))
        
        self.saveButton = UIBarButtonItem(title: "저장", style: .done, target: self, action: #selector(saveButtonDidTap))
        self.saveButton.tintColor = UIColor.Palette.darkGreyBlue
        self.navigationItem.rightBarButtonItem = self.saveButton
    }
    
    //MARK: SET UP ACCESSORYVIEW
    func setUpAccessoryView() {
        ImagePickerController.shared.delegate = self
        self.accessoryView.addTarget(self, selector: #selector(showImagePicker))
        self.accessoryView.hideChatUI()
    }
    
    func setAccessoryViewContraint(height: CGFloat, bottom: CGFloat) {
        self.accessoryViewHeightConstaint.constant = height
        self.accessoryViewBottomConstraint.constant =  bottom
        self.view.layoutIfNeeded()
    }
    
    //MARK: SET UP IMAGECOLLECTIONVIEW
    func setUpImageCollectionView() {
        self.imageCollectionView.setUp(target: self, cell: ImageCollectionViewCell.self)
        let layout = CustomCollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        self.imageCollectionView.collectionViewLayout = layout
    }
    
    func showImageCollectionView(_ value: Bool) {
        UIView.animate(withDuration: 1) {
            self.imageCollectionViewHeightConstraint.constant = value ? 60.0 : 0.0
            self.view.layoutIfNeeded()
        }
    }
    
    //MARK: ACTION
    @objc
    func showImagePicker() {
        showImagePickerController()
    }
    
    @objc
    func closeButtonDidTap() {
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
        self.imageCollectionView.collectionViewLayout.invalidateLayout()
        self.imageCollectionView.reloadData()
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
extension WritingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.image = images[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.images.remove(at: indexPath.row)
        collectionView.deleteItems(at: [indexPath])
    }
}

//https://stackoverflow.com/questions/35639994/uicollectionview-received-layout-attributes-for-a-cell-with-an-index-path-that-d
class CustomCollectionViewFlowLayout: UICollectionViewFlowLayout {
    private var cache = [UICollectionViewLayoutAttributes]()
    override func invalidateLayout() {
        super.invalidateLayout()
        cache.removeAll()
    }
}

