//
//  SearchResultViewController.swift
//  Mosaic
//
//  Created by Zedd on 2018. 8. 18..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class SearchResultViewController: UIViewController {

    
    @IBOutlet weak var tableView: UITableView!
    var searchKeyowrd: String = ""
    static func create(keyword: String) -> SearchResultViewController? {
        let view =  UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: classNameToString) as? SearchResultViewController
        view?.searchKeyowrd = keyword
        return view
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupTableView()
        self.setupNaviation()
    self.navigationController?.navigationBar.isHidden = false
        self.view.backgroundColor = UIColor(hex: "#ff573d")
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.title = self.searchKeyowrd
    self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]


    }
    func setupNaviation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icSearchBack"), style: .plain, target: self, action: #selector(backButtonDidTap))

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

}
extension SearchResultViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultCountTableViewCell.reuseIdentifier, for: indexPath) as? SearchResultCountTableViewCell else { return UITableViewCell() }
            
            return cell
        } else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchResultTableViewCell.reuseIdentifier, for: indexPath) as? SearchResultTableViewCell else { return UITableViewCell() }
            cell.configure()
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
}
class SearchResultCountTableViewCell: UITableViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.countLabel.font = UIFont.nanumRegular(size: 18)
        self.countLabel.textColor = UIColor(hex: "#ffc9c1")
    }
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(count: Int) {
        self.countLabel.text = "\(count)의 결과"
    }
}

class SearchResultTableViewCell: UITableViewCell {
    
    @IBOutlet weak var typeViewTrailing: NSLayoutConstraint!
    static var height: CGFloat { return 141 }

    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var nickNameLabel: UILabel!
    @IBOutlet weak var mainImageView: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var imageViewWidth: NSLayoutConstraint!
    
    @IBOutlet weak var newCommentBackgroundImageView: UIImageView!
    
    @IBOutlet weak var newCommentCountLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupLables()
    }
    
    func setupLables() {
        
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
        self.typeViewTrailing.constant = 20
        
        self.nickNameLabel.font = UIFont.nanumExtraBold(size: 10)
        self.nickNameLabel.textColor = UIColor(hex: "#474747")
        self.commentLabel.font = UIFont.nanumBold(size: 10)
        self.commentLabel.textColor = UIColor(hex: "#fc543a")
        self.lineView.backgroundColor = UIColor(hex: "#dbdbdb")
        self.imageViewWidth.constant = 0
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure() {
        let typeView = TypeView.create(frame: self.typeView.bounds)
        typeView.setup(fontSize: 14)
        typeView.configure(title: "공모전🏆")
        self.typeView.addSubview(typeView)
        self.nickNameLabel.text = "이화여자대학교 | EWHA0001"
        self.dateLabel.text = "3월 22일"
        self.commentLabel.text = "댓글 24"
    }
}
