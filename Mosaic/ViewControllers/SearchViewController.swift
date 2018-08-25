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
    
    @IBOutlet weak var tableView: UITableView!
    
    var recentKeyword: [String] = []
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
        
        self.setupRecentKeyword()
        
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
        
        self.searchView.layer.cornerRadius = 2
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        self.tableView.separatorStyle = .none
        self.tableView.backgroundColor = UIColor(hex: "#ff573d")
    }
    
    func setupRecentKeyword() {
        self.recentKeyword = UserDefaults.standard.array(forKey: "recentKeyword") as? [String] ?? []
        self.recentKeyword.reverse()
        self.tableView.reloadData()
    }
    
    @IBAction func cancelButtonDidTap(_ sender: Any) {
        self.dismiss(animated: false, completion: nil)
    }
}

extension SearchViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.recentKeyword.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SearchTableViewCell.reuseIdentifier, for: indexPath) as? SearchTableViewCell else { return UITableViewCell() }
        cell.configure(recentKeyword: self.recentKeyword[indexPath.item])
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let viewController = SearchResultViewController.create(type: .search(keyword: self.recentKeyword[indexPath.row]), article: nil) else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension SearchViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let viewController = SearchResultViewController.create(type: .search(keyword: textField.text ?? ""), article: nil) else { return false }
        guard let text = textField.text else { return false }
        if !text.isEmpty, !self.recentKeyword.contains(text) { self.recentKeyword.append(text) }
        self.navigationController?.pushViewController(viewController, animated: true)
        UserDefaults.standard.set(self.recentKeyword, forKey: "recentKeyword")
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
