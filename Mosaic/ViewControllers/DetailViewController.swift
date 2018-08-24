//
//  DetailViewController.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 22..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController, TransparentNavBarService, KeyboardControlService {
    //MARK: - PROPERTY
    //MARK: UI
    @IBOutlet weak var deleteButton: UIButton!
    @IBOutlet weak var categoryView: CategoryView!
    @IBOutlet weak var tableView: UITableView!
    
    var scrapBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icScrapNol"),
                                                          style: .plain,
                                                          target: self,
                                                          action: #selector(scrapButtonDidTap))
    //MARK: CONSTRAINT
    @IBOutlet weak var accessoryViewHeight: NSLayoutConstraint!
    @IBOutlet weak var deleteButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButtonBottomConstraint: NSLayoutConstraint!

    //MARK: - METHOD
    //MARK: INIT
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpKeyboard()
        setUpNavigationBar()
        setUpCategoryView()
        setUpTableView()
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
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icClose"),
                                                                style: .plain,
                                                                target: self,
                                                                action: #selector(closeButtonDidTap))
        
        self.navigationItem.rightBarButtonItem = scrapBarButton
        
    }
    //MARK: SET UP TABLEVIEW
    func setUpTableView() {
        self.tableView.setUp(target: self, cell: CommentTableViewCell.self)
        self.tableView.setUp(target: self, cell: RECommentTableViewCell.self)
        self.tableView.allowsSelection = false
        self.tableView.estimatedRowHeight = 50
        self.tableView.rowHeight = UITableViewAutomaticDimension
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
    
    //MAKR: ACTION
    @objc
    func closeButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc
    func scrapButtonDidTap() {
        
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
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    
}
