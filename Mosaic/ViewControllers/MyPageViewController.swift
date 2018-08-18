//
//  MyPageViewController.swift
//  Mosaic
//
//  Created by Zedd on 2018. 8. 18..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class MyPageViewController: UIViewController {

    @IBOutlet weak var collegeImageView: UIImageView!
    
    @IBOutlet weak var nickNameLabel: UILabel!
    
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!

    @IBOutlet weak var profileView: UIView!
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    static func create() -> MyPageViewController? {
        return UIStoryboard(name: "MyPage", bundle: nil).instantiateViewController(withIdentifier: classNameToString) as? MyPageViewController
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        
        self.setupProfileView()
       
        self.setupTableView()
        
        self.view.backgroundColor = UIColor(hex: "#ff573d")

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
    
    }
    func setupNavigation() {
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icSearchBack")!, style: .plain, target: self, action: #selector(backButtonDidTap))
        
    }
    @objc
    func backButtonDidTap() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func setupProfileView() {
        self.profileView.backgroundColor = UIColor(hex: "#ff573d")
        self.nickNameLabel.font = UIFont.nanumExtraBold(size: 14)
        self.nickNameLabel.textColor = UIColor.white
        self.nickNameLabel.text = "이화여자대학교 | SOGANG2039"
        self.emailLabel.font = UIFont.nanumExtraBold(size: 12)
        self.emailLabel.textColor = UIColor(hex: "#ffc9c1")
        self.emailLabel.text = "yurisung@ewhain.netz"
    
    }
    
    func setupTableView() {
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.tableFooterView = UIView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

extension MyPageViewController: UITableViewDelegate, UITableViewDataSource {
    enum Title: Int {
        case scrap
        case myArticle
        case auth
        
        var titleLabel: String {
            switch self {
            case .scrap:
                return "내가 스크랩한 글"
            case .myArticle:
                return "내가 작성한 글"
            case .auth:
                return "인증 초기화"
            }
        }
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
        
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MyPageTableViewCell.reuseIdentifier, for: indexPath) as? MyPageTableViewCell else { return UITableViewCell() }
        cell.configure(title: Title.init(rawValue: indexPath.row)?.titleLabel, isHiddenNewImage: true, isCountHidden: true)
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MyPageTableViewCell.height
    }

    
}
class MyPageTableViewCell: UITableViewCell {
    
    static var height: CGFloat { return 56 }
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var newImageView: UIImageView!
    
    @IBOutlet weak var countLabel: UILabel!
    
    @IBOutlet weak var myArticleCountLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel.font = UIFont.nanumBold(size: 14)
        self.newImageView.backgroundColor = UIColor(hex: "#64c8dd")
        self.newImageView.layer.cornerRadius = self.newImageView.frame.width / 2
        self.myArticleCountLabel.font = UIFont.nanumExtraBold(size: 10)
        self.myArticleCountLabel.textColor = .white
        
        self.countLabel.font = UIFont.nanumBold(size: 14)
        self.countLabel.textColor = UIColor(hex: "#fb5339")
        
        self.selectionStyle = .none
        self.separatorInset = UIEdgeInsets.zero
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(title: String?, isHiddenNewImage: Bool = false, isCountHidden: Bool = false) {
        self.titleLabel.text = title
        self.newImageView.isHidden = isHiddenNewImage
        self.countLabel.isHidden = isCountHidden
    }
}