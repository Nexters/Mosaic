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
    
    var scrapBarButton: UIBarButtonItem = UIBarButtonItem(image: UIImage(named: "icScrapNol"),
                                                          style: .plain,
                                                          target: self,
                                                          action: #selector(scrapButtonDidTap))
    //MARK: CONSTRAINT
    @IBOutlet weak var accessoryViewHeight: NSLayoutConstraint!
    @IBOutlet weak var deleteButtonHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var deleteButtonBottomConstraint: NSLayoutConstraint!

    //MARK: - METHOD
    override func viewDidLoad() {
        super.viewDidLoad()

        setUpKeyboard()
        setUpNavigationBar()
        
//        self.accessoryViewHeight.constant = CommentAccessoryView.changedHeight
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
    
    //MARK: SET UP NAVIGATIONBAR
    func showDeleteButton() {
        self.deleteButtonHeightConstraint.constant = 52
    }
    
    //MARK: SET UP CATEGORYVIEW
    func setCategoryView() {
        self.categoryView.font = UIFont.nanumExtraBold(size: 16)
        self.categoryView.category = (emoji: "🤫", title: "익명제보")
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
