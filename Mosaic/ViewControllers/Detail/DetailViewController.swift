//
//  DetailViewController.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 22..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit
import TLPhotoPicker
import Photos

class DetailViewController: UIViewController, TransparentNavBarService, KeyboardControlService {
    //MARK: - PROPERTY
    //MARK: UI
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var pagingImageCollectionView: PagingImageCollectionView!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var commentCountLable: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var categoryView: CategoryView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var commentView: UIView!
    @IBOutlet weak var accessoryView: CommentAccessoryView!
    var scrapBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icScrapNol")?.withRenderingMode(.alwaysTemplate),
                                                          style: .plain,
                                                          target: self,
                                                          action: #selector(scrapButtonDidTap))
    //MARK: CONSTRAINT
    @IBOutlet weak var accessoryViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButtonBottomConstraint: NSLayoutConstraint!
    //MARK: STORED OR COMPUTED
    var selectedAssets = [TLPHAsset]() {
        didSet {
            self.selectedImage = self.selectedAssets.first?.fullResolutionImage
        }
    }
    var selectedImage: UIImage?
    var article: Article?
    //MARK: - METHOD
    //MARK: INIT
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpKeyboard()
        setUpNavigationBar()
        setUpCategoryView()
        setUpTableView()
        setUpCommentView()
        setUpPagingImageCollectionView()
        setUpAccessoryView()
        setUpUI(article: self.article!)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        guard let headerView = tableView.tableHeaderView else {return }
        let size = headerView.systemLayoutSizeFitting(UILayoutFittingCompressedSize)
        if headerView.frame.size.height != size.height {
            headerView.frame.size.height = size.height
            tableView.tableHeaderView = headerView
            tableView.layoutIfNeeded()
        }
    }
    
    //MARK: SET UP KEYBOARD
    func setUpKeyboard() {
        self.setKeyboardControl(willShow: { [weak self] (rect, duration) in
            guard let `self` = self else {return}
            UIView.animate(withDuration: duration, animations: {
                self.deleteButtonBottomConstraint.constant = rect.height - bottomInset
                self.view.layoutIfNeeded()
            })
        }, willHide: { [weak self] (rect, duration) in
            guard let `self` = self else {return}
            UIView.animate(withDuration: duration, animations: {
                self.deleteButtonBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            })
        })
    }
    
    //MARK: SET UP NAVIGATIONBAR
    func setUpNavigationBar() {
        self.transparentNavigationBar()
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icClose")?.withRenderingMode(.alwaysOriginal),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(closeButtonDidTap))
        
        self.navigationItem.rightBarButtonItem = scrapBarButton
        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.Palette.silver
//        self.navigationItem.rightBarButtonItem?.tintColor = UIColor.Palette.coral
    }
    
    //MARK: SET UP UI
    func setUpUI(article: Article) {
        let label = UILabel()
        guard let writer = article.writer else {return}
        
        let university = NSMutableAttributedString(string: writer.university?.name ?? "", attributes:[
            NSAttributedStringKey.foregroundColor: UIColor.Palette.coral,
            NSAttributedStringKey.font: UIFont.nanumBold(size: 14.0)])
        let section = NSMutableAttributedString(string: " | ", attributes:[
            NSAttributedStringKey.foregroundColor: UIColor.Palette.silver,
            NSAttributedStringKey.font: UIFont.nanumBold(size: 14.0)])
        let nickname = NSMutableAttributedString(string: writer.nickName, attributes:[
            NSAttributedStringKey.foregroundColor: UIColor.Palette.coolGrey,
            NSAttributedStringKey.font: UIFont.nanumBold(size: 14.0)])
        university.append(section)
        university.append(nickname)
        label.attributedText = university
        self.navigationItem.titleView = label
        
        guard let category = article.category?.emojiTitle else {return}
        self.categoryView.category = category
        
        self.contentLabel.text = article.content
        
        self.commentCountLable.text = String(describing: article.replies)
        
        self.datelabel.text = Date().text(article.createdAt) 
    }
    
    //MARK: SET UP TABLEVIEW
    func setUpTableView() {
        self.tableView.setUp(target: self, cell: CommentTableViewCell.self)
        self.tableView.setUp(target: self, cell: RECommentTableViewCell.self)
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tableViewDidTapped)))
    }
    
    @objc
    func tableViewDidTapped() {
        self.view.endEditing(true)
    }
    
    //MARK: SET UP NAVIGATIONBAR
    func showDeleteButton() {
        self.deleteButtonHeightConstraint.constant = 52
    }
    
    //MARK: SET UP CATEGORYVIEW
    func setUpCategoryView() {
        self.categoryView.backgroundColor = .clear
        self.categoryView.category = (emoji: "🤫", title: "익명제보")
        self.categoryView.setUp()
    }
    
    //MARK: SET UP COMMENTVIEW
    func setUpCommentView() {
        self.commentView.layer.addBorder([.top, .bottom],
                                         color: UIColor.Palette.paleGrey,
                                         width: 1.0)
    }
    
    //MARK: SET UP PAGINGIMAGECOLLECTIONVIEW
    func setUpPagingImageCollectionView() {
        self.pagingImageCollectionView.images = [#imageLiteral(resourceName: "imgYonseiuniv"), #imageLiteral(resourceName: "imgBackEwhauniv"), #imageLiteral(resourceName: "imgBackKoreauniv"), #imageLiteral(resourceName: "imgBackKoreauniv2")]
    }
    
    //MARK: SET UP ACCESSORYVIEW
    func setUpAccessoryView() {
        self.accessoryView.imageButtonAddTarget(self, action: #selector(imageButtonDidTapped))
        self.accessoryView.sendButtonAddTarget(self, action: #selector(messageButtonDidTapped))
        self.accessoryView.deleteButtonAddTarget(self, action: #selector(deleteButtonDidTapped))
    }
    
    //MAKR: - ACTION
    @objc
    func closeButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func scrapButtonDidTap() {
        
    }
    
    @objc
    func replyButtonDidTap(_ sender: ParameterButton) {
        guard let nickname = sender.params["nickname"] as? String else {return}
        self.accessoryView.setNicknameLabel(nickname)
    }
    
    @objc
    func imageButtonDidTapped() {
        var configure = TLPhotosPickerConfigure()
        configure.numberOfColumn = 3
        configure.maxSelectedAssets = 1
        configure.mediaType = PHAssetMediaType.image
        configure.cancelTitle = "취소"
        configure.doneTitle = "완료"
        
        let photoPicker = TLPhotosPickerViewController()
        photoPicker.delegate = self
        photoPicker.configure = configure
        photoPicker.selectedAssets = selectedAssets
        photoPicker.didExceedMaximumNumberOfSelection = { (picker) in
            UIAlertController.showMessage("선택가능한 숫자를 초과했습니다.")
        }
        self.present(photoPicker, animated: true, completion: nil)
    }
    
    @IBAction func messageButtonDidTapped(_ sender: UIButton) {
        self.view.endEditing(true)
    }
    
    @objc
    func deleteButtonDidTapped() {
        self.selectedAssets = []
        changeAccessoryViewHeight(true)
    }
    
    func changeAccessoryViewHeight(_ hide: Bool) {
        UIView.animate(withDuration: 0.5) {
            self.accessoryViewHeightConstraint.constant =
                hide ? CommentAccessoryView.normalHeight : CommentAccessoryView.changedHeight
            self.accessoryView.showImageView(self.selectedImage)
            self.view.layoutIfNeeded()
        }
    }
    
    
    func fetchArticle() {
        guard let article = self.article,
            let uuid = article.uuid else {return}
        APIRouter.shared.request(ArticleService.get(scriptUuid: uuid)) { [weak self] (code: Int?, article: Article?) in
            guard let `self` = self else {return}
            self.article = article
        }
    }
}

//MARK: - EXTENSION
//MARK: UITABLEVIEWDELEGATE, UITABLEVIEWDATASOURCE
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.row == 1 {
            let recell: RECommentTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            recell.str = "Note we have also set the tableview’s rowHeight property. By doing so, we have can expect the self-sizing behavior for a cell. Furthermore, I have noticed some developers override heightForRowAtIndexPath to achieve a similar effect. This should be avoided for the following reason."
            return recell
        }
        else {
            let cell: CommentTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.replyButton.params = ["nickname" : cell.nicknameLabel.text!]
            cell.replyButton.addTarget(self, action: #selector(replyButtonDidTap(_:)), for: .touchUpInside)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
}

//MARK: TLPhotosPickerViewControllerDelegate
extension DetailViewController: TLPhotosPickerViewControllerDelegate {
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
        changeAccessoryViewHeight(false)
    }
}


