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
    @IBOutlet weak var replyCountLable: UILabel!
    @IBOutlet weak var datelabel: UILabel!
    @IBOutlet weak var categoryView: CategoryView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var replyView: UIView!
    @IBOutlet weak var accessoryView: CommentAccessoryView!
    var scrapBarButton: UIBarButtonItem!
    let footerView = FooterView()
    let refreshControl = UIRefreshControl()
    //MARK: CONSTRAINT
    @IBOutlet weak var pagingImageCollectionViewHeightConstraint: NSLayoutConstraint!
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
    var upperReplyUUID: String = ""
    var replies: [Reply] = [] {
        didSet {
            let sequence = compare(oldValue, self.replies, with: {$0 == $1})
            guard let inserted = sequence.inserted.first else {return}
            let index = self.replies.index(where: { $0 == inserted } )
             //forEach({ print($0.content) })
        }
    }
    var isScraped: Bool = false {
        didSet {
            setScrapButton(self.isScraped)
        }
    }
    var showDeleteButton: Bool = false
    //MARK: - METHOD
    //MARK: INIT
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpKeyboard()
        setUpNavigationBar()
        setUpCategoryView()
        setUpTableView()
        setUpAccessoryView()
        if let article = self.article {
            setUpUI(article: article)
        }
        fetchReplies()
        setUpDeleteButton()
        if showDeleteButton {
            changeDeleteButtonHeight()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .lightContent
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
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
        
        self.replyView.layer.addBorder([.top, .bottom],
                                         color: UIColor.Palette.paleGrey,
                                         width: 1.0)
    }
    
    //MARK: SET UP KEYBOARD
    func setUpKeyboard() {
        self.setKeyboardControl(willShow: { [weak self] (rect, duration) in
            guard let `self` = self else {return}
            UIView.animate(withDuration: duration, animations: {
                self.deleteButtonBottomConstraint.constant = rect.height - bottomInset
                self.view.layoutIfNeeded()
            }, completion: { (value) in
                self.scrollToBottom()
            })
        }, willHide: { [weak self] (rect, duration) in
            guard let `self` = self else {return}
            UIView.animate(withDuration: duration, animations: {
                self.deleteButtonBottomConstraint.constant = 0
                self.view.layoutIfNeeded()
            }, completion: { (value) in
                self.scrollToBottom()
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
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icScrapNol")?.withRenderingMode(.alwaysTemplate),
                                                                 style: .plain,
                                                                 target: self,
                                                                 action: #selector(scrapButtonDidTap))
        self.scrapBarButton = self.navigationItem.rightBarButtonItem
        setScrapButton(false)
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
        
        self.pagingImageCollectionViewHeightConstraint.constant = 0
        self.pagingImageCollectionView.isHidden = true
        if let articleURLs = article.imageUrls, !articleURLs.isEmpty {
            self.pagingImageCollectionView.isHidden = false
            self.pagingImageCollectionViewHeightConstraint.constant = 300
            setUpPagingImageCollectionView(imageURLS: articleURLs)
        }
        
        guard let category = article.category?.emojiTitle else {return}
        self.categoryView.category = category
        
        self.contentLabel.text = article.content
        
        self.datelabel.text = Date().text(article.createdAt)
        
        self.isScraped = article.isScraped
    }
    
    //MARK: SET UP TABLEVIEW
    func setUpTableView() {
        self.tableView.setUp(target: self, cell: CommentTableViewCell.self)
        self.tableView.setUp(target: self, cell: RECommentTableViewCell.self)
        self.tableView.estimatedRowHeight = 30
        self.tableView.rowHeight = UITableViewAutomaticDimension
        self.tableView.separatorStyle = .none
        self.tableView.alwaysBounceVertical = true
        self.tableView.showsVerticalScrollIndicator = false
        self.tableView.allowsSelection = false
        self.tableView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tableViewDidTapped)))
        
        self.refreshControl.tintColor = UIColor.Palette.coral
        self.refreshControl.addTarget(self, action: #selector(pullRefresh), for: .valueChanged)
        self.tableView.addSubview(refreshControl)
    }
    
    func setUpDeleteButton() {
//        showDeleteButton()
        self.deleteButton.addTarget(self, action: #selector(showDeleteAlert), for: .touchUpInside)
    }
    
    @objc
    func tableViewDidTapped() {
        self.view.endEditing(true)
    }
    
    //MARK: SET UP NAVIGATIONBAR
    func changeDeleteButtonHeight() {
        self.deleteButtonHeightConstraint.constant = 52
    }
    
    //MARK: SET UP CATEGORYVIEW
    func setUpCategoryView() {
        self.categoryView.backgroundColor = .clear
        self.categoryView.category = (emoji: "🤫", title: "익명제보")
        self.categoryView.setUp()
    }
    
    //MARK: SET UP PAGINGIMAGECOLLECTIONVIEW
    func setUpPagingImageCollectionView(imageURLS: [String]) {
        self.pagingImageCollectionView.imageURLs = imageURLS
    }
    
    //MARK: SET UP ACCESSORYVIEW
    func setUpAccessoryView() {
        self.accessoryView.imageButtonAddTarget(self, action: #selector(imageButtonDidTapped))
        self.accessoryView.sendButtonAddTarget(self, action: #selector(messageButtonDidTapped))
        self.accessoryView.deleteButtonAddTarget(self, action: #selector(accessoryViewDeleteButtonDidTapped))
        self.accessoryView.textFieldAddTarget(self, action: #selector(textfieldDidTapped(_:)))
    }
    
    func setScrapButton(_ value: Bool) {
        self.scrapBarButton.tintColor = value ? UIColor.Palette.coral : UIColor.Palette.silver//setEnable(value, color: value ? UIColor.Palette.coral : UIColor.Palette.silver)
    }
    
    //MAKR: - ACTION
    @objc
    func closeButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func scrapButtonDidTap() {
        guard let uuid = self.article?.uuid else {return}
        requestScrap(uuid)
    }
    
    @objc
    func replyButtonDidTap(_ sender: ParameterButton) {
        guard let uuid = sender.params["uuid"] as? String else {return}
        guard let nickname = sender.params["nickname"] as? String else {return}
        self.accessoryView.setNicknameLabel(UpperReply(uuid: uuid, name: nickname))
        self.accessoryView.textField.becomeFirstResponder()
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
        postReply(method: {
            self.accessoryView.reset()
            self.changeAccessoryViewHeight(true)
        })
        
    }
    
    @objc
    func accessoryViewDeleteButtonDidTapped() {
        changeAccessoryViewHeight(true)
    }
    
    func changeAccessoryViewHeight(_ hide: Bool) {
        if hide {
            self.selectedAssets = []
        }
        UIView.animate(withDuration: 0.5) {
            self.accessoryViewHeightConstraint.constant =
                hide ? CommentAccessoryView.normalHeight : CommentAccessoryView.changedHeight
            self.accessoryView.showImageView(self.selectedImage)
            self.view.layoutIfNeeded()
        }
    }
    
    
//    func fetchArticle() {
//        guard let article = self.article,
//            let uuid = article.uuid else {return}
//        APIRouter.shared.request(ArticleService.get(scriptUuid: uuid)) { [weak self] (code: Int?, article: Article?) in
//            guard let `self` = self else {return}
//            self.article = article
//            guard let article = self.article else {return}
//            self.setUpUI(article: article)
//        }
//    }
    
    @objc
    func pullRefresh() {
        fetchReplies()
    }
    
    @objc
    func fetchReplies(method: (()->())? = nil) {
        guard let article = self.article,
            let uuid = article.uuid else {return}
        self.refreshControl.endRefreshing()
        APIRouter.shared.requestArray(ReplyService.getReplies(scriptUuid: uuid)) { [weak self] (code: Int?, replies: [Reply]?) in
            guard let `self` = self else {return}
            guard let replies = replies else {return}
            self.replies = replies
            self.replyCountLable.text = String(describing: self.replies.filter{$0.valid}.count)
            if self.replies.isEmpty {
                guard let headerView = self.tableView.tableHeaderView else {return }
                let bounds = self.tableView.bounds
                var height: CGFloat = 50
                if bounds.height > headerView.bounds.height {
                    height = bounds.height - headerView.bounds.height
                }
                self.footerView.frame = CGRect(x: 0, y: 0,
                                               width: bounds.width,
                                               height: height)
                self.tableView.tableFooterView = self.footerView
            } else {
                self.tableView.tableFooterView = UIView()
            }
            self.tableView.reloadData()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                method?()
            })
        }
    }
    
    func postReply(method: (()->())? = nil) {
        guard let content = self.accessoryView.textField.text else {return}
        guard let article = self.article,
                let uuid = article.uuid else {return}
        
        APIRouter.shared.upload(ReplyService.add(content: content,
                                                 scriptUuid: uuid,
                                                 upperReplyUuid: self.accessoryView.upperReply?.uuid ?? ""),
                                imageKey: "imgFile",
                                images: [self.selectedImage]) { [weak self] (code: Int?, reply: Reply?) in
                                    guard let `self` = self else {return}
                                    if let method = method {
                                        method()
                                    }
                                    guard let reply = reply else {return}
                                    self.fetchReplies(method: {
                                        
                                        guard let index = self.replies.index(where: {$0.uuid == reply.uuid}) else {return}
                                        let indexPath = IndexPath(row: index, section: 0)
                                        if self.tableView.cellForRow(at: indexPath) != nil {
                                            self.tableView.scrollToRow(at: indexPath, at: UITableViewScrollPosition.bottom, animated: true)
                                        }
                                    })
        }
    }
    
    func requestScrap(_ uuid: String) {
        APIRouter.shared.request(ScrapService.add(scriptUuid: uuid)) { [weak self] (code: Int?, article: Article?) in
            guard let `self` = self else {return}
            guard let code = code else {return}
            switch code {
            case 200:
                guard let article = article else {return}
                self.isScraped = article.isScraped
            default:
                break
            }
        }
    }
    
    @objc
    func textfieldDidTapped(_ textField: UITextField) {
        
        
    }
    
    func scrollToBottom() {
        if !self.replies.isEmpty {
            var indexPath = IndexPath(row: 0, section: 0)
            if let upper = self.accessoryView.upperReply,
                let index = self.replies.index(where: {$0.uuid == upper.uuid}){
                indexPath = IndexPath(row: index, section: 0)

            } else {
                indexPath = IndexPath(row: self.replies.count - 1, section: 0)
            }
            self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        } else {
            self.tableView.setContentOffset(CGPoint(x: 0,
                                                    y: self.tableView.contentSize.height - self.tableView.bounds.height),
                                            animated: true)
        }
    }
    
    @objc
    func showDeleteAlert() {
        UIAlertController.showAlert(title: "삭제",
                                    message: "게시글을 삭제하시겠습니까?",
                                    actions: [UIAlertAction(title: "취소", style: .default, handler: nil),
                                              UIAlertAction(title: "삭제", style: .destructive, handler: { (action) in
                                                self.deleteScript()
                                              })])
    }
    
    func deleteScript() {
        guard let article = self.article else {return}
        guard let uuid = article.uuid else {return}
        APIRouter.shared.request(ArticleService.delete(scriptUuid: uuid)) { (code: Int?, article: Article?) in
            guard let code = code else {return}
            switch code {
            case 200:
                self.navigationController?.popViewController(animated: true)
                self.dismiss(animated: true, completion: nil)
            default:
                break
            }
        }
    }
    
    func deleteReply(uuid: String, method: (()->())? = nil) {
        print(uuid)
        APIRouter.shared.request(ReplyService.delete(replyUuid: uuid)) { (code: Int?, _: None?) in
            guard let code = code else {return}
            switch code {
            case 200:
                if let method = method {
                    method()
                }
            default:
                break
            }
        }
    }
}

//MARK: - EXTENSION
//MARK: UITABLEVIEWDELEGATE, UITABLEVIEWDATASOURCE
extension DetailViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let reply = self.replies[indexPath.row]
        if reply.upperReplyUuid.isEmpty  {
            let cell: CommentTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            cell.replyButton.params = ["uuid"       : reply.uuid,
                                       "nickname"   : reply.writer?.nickName ?? ""]
            cell.replyButton.addTarget(self, action: #selector(replyButtonDidTap(_:)), for: .touchUpInside)
            cell.reply = reply
            return cell
        } else {
            let recell: RECommentTableViewCell = tableView.dequeueReusableCell(forIndexPath: indexPath)
            recell.reply = reply
            return recell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.replies.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        switch editingStyle {
        case .delete:
            UIAlertController.showAlert(title: "삭제",
                                        message: "선택한 댓글을 삭제하시겠습니까?",
                                        actions: [UIAlertAction(title: "취소", style: .default, handler: nil),
                                                  UIAlertAction(title: "삭제", style: .destructive, handler: { (alertAction) in
                                                    let reply = self.replies[indexPath.row]
                                                    self.deleteReply(uuid: reply.uuid) {
                                                        self.fetchReplies(method: {
                                                            if tableView.cellForRow(at: indexPath) != nil{
                                                                tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                                                            }
                                                        })
                                                    }
                                                  })])
        default:
            break
        }
    }
    
    
    func tableView(_ tableView: UITableView, titleForDeleteConfirmationButtonForRowAt indexPath: IndexPath) -> String? {
        return "삭제"
    }
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        let reply = self.replies[indexPath.row]
        return (reply.writer?.uuid == APIRouter.shared.me?.uuid) && reply.valid
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


