//
//  SearchResultViewController.swift
//  Mosaic
//
//  Created by Zedd on 2018. 8. 18..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

enum ResultType {
    case search(keyword: String)
    case scrap
    case myArticles
}

class SearchResultViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    var searchKeyowrd: String = ""
    var type: ResultType?
    var articles: [Article]?
    
    static func create(type: ResultType, article: [Article]?) -> SearchResultViewController? {
        let view =  UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: classNameToString) as? SearchResultViewController
        view?.type = type
        //view?.articles = article
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        
        self.setupNaviation()
        
        self.view.backgroundColor = UIColor(hex: "#ff573d")
        
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.requestArticles()
    }
    
    func setupNaviation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icSearchBack"), style: .plain, target: self, action: #selector(backButtonDidTap))
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.isHidden = false
        
        
        var navigationTitle: String = ""
        switch self.type! {
        case .search(let keyword):
            navigationTitle = keyword
            self.searchKeyowrd = keyword
        case .scrap:
            navigationTitle = "내가 스크랩한 글"
        case .myArticles:
            navigationTitle = "내가 작성한 글"
        }
        self.title = navigationTitle
        self.navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
    }
    
    func requestArticles() {
        switch self.type! {
        case .search:
//            ApiManager.shared.requestArticle(at: self.searchKeyowrd) { (code, articles) in
//                if code == 200 {
//                    self.articles = articles
//                    self.tableView.reloadData()
//                }
//            }
            APIRouter.shared.requestArray(ArticleService.search(keywork: self.searchKeyowrd)) { (code: Int?, articles: [Article]?) in
                guard let code = code else {return}
                switch code {
                case 200:
                    self.articles = articles
                    self.tableView.reloadData()
                default:
                    break
                }
            }
        case .scrap:
//            ApiManager.shared.requestMyScraps { (code, articles) in
//                if code == 200 {
//                    self.articles = articles
//                    print(self.articles)
//                    self.tableView.reloadData()
//                }
//            }
            APIRouter.shared.requestArray(MyProfileService.scraps) { (code: Int?, articles: [Article]?) in
                guard let code = code else {return}
                switch code {
                case 200:
                    self.articles = articles
                    self.tableView.reloadData()
                default:
                    break
                }
            }
        case .myArticles:
//            ApiManager.shared.requestMyArticles { (code, articles) in
//                if code == 200 {
//                    self.articles = articles
//                    self.tableView.reloadData()
//                }
//            }
            APIRouter.shared.requestArray(ArticleService.mine) { (code: Int?, articles: [Article]?) in
                guard let code = code else {return}
                switch code {
                case 200:
                    self.articles = articles
                    self.tableView.reloadData()
                default:
                    break
                }
            }
        }

    }
    
    @objc
    func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.backgroundColor = UIColor(hex: "#ff573d")
    }
    
    @objc
    func deleteButtonDidTap(_ sender: ParameterButton) {
        guard let uuid = sender.params["uuid"] as? String else {return}
        
        print(uuid)
        
       
        

    }
    
}
extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource, SearchResultDelegate {
    func deleteDidTapped(_ article: Article) {
        guard let uuid = article.uuid else {return}
        print(article.content)
        
        UIAlertController.showAlert(title: "삭제",
                                    message: "선택한 게시글을 삭제하시겠습니까?",
                                    actions: [UIAlertAction(title: "취소", style: .default, handler: nil),
                                              UIAlertAction(title: "삭제", style: .destructive, handler: { (alertAction) in
                                                APIRouter.shared.request(ArticleService.delete(scriptUuid: uuid)) { (code: Int?, article: Article?) in
                                                    self.requestArticles()
                                                }
                                              })])
    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return (self.articles?.count ?? 0) + 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCountTableViewCell.reuseIdentifier, for: indexPath) as? SearchResultCountTableViewCell else { return UITableViewCell() }
            cell.configure(count: self.articles?.count ?? 0)
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseIdentifier, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
            cell.delegate = self
            cell.configure(type: self.type!, article: self.articles?[indexPath.section-1])
            return cell
            
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return UITableViewAutomaticDimension
        } else {
            return SearchResultTableViewCell.height
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 10
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .clear
        return view
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController: DetailViewController = DetailViewController.create(storyboard: "Detail") as? DetailViewController else {return}
        guard let articles = self.articles else {return}
        viewController.article = articles[indexPath.section - 1]
        if let type = self.type {
            switch type {
            case .myArticles:
                viewController.showDeleteButton = true
            default:
                break
            }
        }
        let navigationController = UINavigationController(rootViewController: viewController)
        self.present(navigationController, animated: true, completion: nil)
    }
}
class SearchResultCountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupLables()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setupLables() {
        self.countLabel.font = UIFont.nanumRegular(size: 18)
        self.countLabel.textColor = UIColor(hex: "#ffc9c1")
    }
    
    func configure(count: Int) {
        self.countLabel.text = count == 0 ? "검색결과가 없습니다. :(" : "\(count)개의 결과"
    }
}

protocol SearchResultDelegate {
    func deleteDidTapped(_ article: Article)
}
class SearchResultTableViewCell: UITableViewCell {
    
    static var height: CGFloat { return 141 }

    @IBOutlet weak var typeViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrapImageViewWidth: NSLayoutConstraint!
    @IBOutlet weak var scrapImageView: UIImageView!
    @IBOutlet weak var commentLabelForMine: UILabel!
    @IBOutlet weak var typeViewTrailing: NSLayoutConstraint!
    
    @IBOutlet weak var typeView: CategoryView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var newCommentBackgroundImageView: UIImageView!
    
    @IBOutlet weak var newCommentCountLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    var article: Article?
    var type: ResultType?
    var delegate: SearchResultDelegate?
    let descriptionAttribute: [NSAttributedStringKey: Any] = [
        .font: UIFont.nanumRegular(size: 13),
        .foregroundColor: UIColor(hex: "#474747")
    ]
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setUpUI()
    }
    
    func setUpUI() {
        self.selectionStyle = .none
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        let descriptionAttribute: [NSAttributedStringKey: Any] = [
            .font: UIFont.nanumRegular(size: 13),
            .foregroundColor: UIColor(hex: "#474747"),
            .paragraphStyle: paragraphStyle
        ]
        self.descriptionLabel.attributedText = NSAttributedString(string: self.descriptionLabel.text ?? "", attributes: descriptionAttribute)
        self.dateLabel.font = UIFont.nanumBold(size: 10)
        self.dateLabel.textColor = UIColor(hex: "#999999")
        self.layer.cornerRadius = 2
        self.newCommentBackgroundImageView.backgroundColor = UIColor(hex: "#64c8dd")
        
        self.newCommentBackgroundImageView.isHidden = true
        self.newCommentCountLabel.font = UIFont.nanumExtraBold(size: 10)
        self.newCommentCountLabel.textColor = .white
        self.newCommentCountLabel.isHidden = true
        //self.typeViewTrailing.constant = 20
        
        self.nickNameLabel.font = UIFont.nanumExtraBold(size: 10)
        self.nickNameLabel.textColor = UIColor(hex: "#474747")
        self.commentLabel.font = UIFont.nanumBold(size: 10)
        self.commentLabel.textColor = UIColor(hex: "#fc543a")
        self.commentLabel.isUserInteractionEnabled = false

        self.lineView.backgroundColor = UIColor(hex: "#dbdbdb")
        self.imageViewWidth.constant = 0
        self.mainImageView.clipsToBounds = true
        self.mainImageView.kf.indicatorType = .activity
        
        self.commentLabelForMine.font = UIFont.nanumBold(size: 10)
        self.commentLabelForMine.textColor = UIColor(hex: "#999999")
        self.commentLabelForMine.isHidden = true
        
        self.scrapImageView.isHidden = true
        self.scrapImageViewWidth.constant = 0
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.setUpUI()
    }
        
    func configure(type: ResultType, article: Article?) {
        guard let article = article else { return }
        self.article = article

        self.type = type
        
        self.descriptionLabel.attributedText = NSAttributedString(string: article.content ?? "", attributes: self.descriptionAttribute)
        
        if article.imageUrls?.isEmpty == true {
            self.imageViewWidth.constant = 0
            self.imageView?.image = nil
        } else {
            self.imageViewWidth.constant = 59
           let url = URL(string: article.imageUrls?.first ?? "")
            self.mainImageView.kf.setImage(with: url)
        }

        self.typeView.backgroundColor = .clear
        self.typeView.category = (emoji: article.category!.emoji, title: article.category!.name)
        self.typeView.setUp()
        self.typeView.layoutIfNeeded()
        self.typeViewWidth.constant = (article.category!.emoji + article.category!.name).width(font: UIFont.nanumExtraBold(size: 14)) + 10
        
        switch type {
        case .search:
            self.commentLabel.text = "댓글 \(article.replies)"
            self.nickNameLabel.text = "\(article.writer?.university?.name ?? "") | \(article.writer?.nickName ?? "")"
        case .scrap:
            self.scrapImageViewWidth.constant = 30
            self.scrapImageView.isHidden = false
            self.commentLabel.text = "댓글 \(article.replies)"
            self.nickNameLabel.text = "\(article.writer?.university?.name ?? "") | \(article.writer?.nickName ?? "")"
        case .myArticles:
            self.nickNameLabel.font = UIFont.nanumBold(size: 10)
            self.nickNameLabel.textColor = UIColor(hex: "#999999")
            self.nickNameLabel.sizeToFit()
            self.commentLabelForMine.isHidden = false
            self.commentLabelForMine.text = "댓글 \(article.replies)"
            self.dateLabel.isHidden = true
            self.commentLabel.text = "삭제"
            self.nickNameLabel.text = Date().text(article.createdAt)
            
            self.commentLabel.isUserInteractionEnabled = true
            self.commentLabel.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(deleteLabelDidTap)))
        }
        self.dateLabel.text = Date().text(article.createdAt)
        self.layoutIfNeeded()
    }
    
    @objc
    func deleteLabelDidTap() {
        guard let article = self.article else {return}
        self.delegate?.deleteDidTapped(article)
    }
}
