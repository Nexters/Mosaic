//
//  SearchViewController.swift
//  Mosaic
//
//  Created by Zedd on 2018. 8. 18..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class SearchViewController: UIViewController {
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var searchView: UIView!
    
    var recentKeyword: [String] = [
        "이화여자대학교 인근 맛집", "사용자조사방법론", "인포메이션아키텍쳐", "전성진 교수님 수업 분위기", "이대 주변 스터디룸"
    ]
    
    @IBOutlet weak var tableView: UITableView!
    
    static func create() -> SearchViewController? {
        return UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: classNameToString) as? SearchViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupSearchBar()
        
        self.setupTableView()
        
        self.view.backgroundColor = UIColor(hex: "#ff573d")
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.isHidden = true
    }
    
    func setupSearchBar() {
       self.searchView.backgroundColor = UIColor(hex: "#e62f12")
        let cancelAttribute: [NSAttributedStringKey: Any] = [
            .font: UIFont.nanumBold(size: 14),
            .foregroundColor: UIColor.white
        ]
        self.cancelButton.setAttributedTitle(NSAttributedString(string: "취소", attributes: cancelAttribute), for: .normal)
        self.searchTextField.becomeFirstResponder()
        
        let placeholderAttribute: [NSAttributedStringKey: Any] = [
            .font: UIFont.nanumBold(size: 13),
            .foregroundColor: UIColor(hex: "#fe563c")
        ]
        
        self.searchTextField.attributedPlaceholder = NSAttributedString(string: "검색어를 입력하세요", attributes: placeholderAttribute)
        self.searchTextField.returnKeyType = .search
        self.searchTextField.delegate = self
        self.searchTextField.textColor = .white
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(hex: "#ff573d")
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        cell.configure(recentKeyword: self.recentKeyword[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let viewController = SearchResultViewController.create(type: .search(keyword: textField.text ?? "")) else { return false }
        self.navigationController?.pushViewController(viewController, animated: true)
        return true
    }
}
class SearchTableViewCell: UITableViewCell {
    @IBOutlet weak var recentSearchKeywordLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setupLabels()
        self.selectionStyle = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func setupLabels() {
        self.recentSearchKeywordLabel.font = UIFont.nanumBold(size: 13)
        self.recentSearchKeywordLabel.textColor = UIColor(hex: "#ffc9c1")
    }
    
    func configure(recentKeyword: String) {
        self.recentSearchKeywordLabel.text = "-   \(recentKeyword)"
    }
}
