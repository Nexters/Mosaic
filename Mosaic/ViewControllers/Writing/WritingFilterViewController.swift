//
//  WritingFilterViewController.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 20..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit


class WritingFilterViewController: UIViewController, TransparentNavBarService {

    @IBOutlet weak var collectionView: UICollectionView!
    var previousViewController: WritingViewController?
    var selectedCategory: Categories? {
        set {
            self.previousViewController?.selectedCategory = newValue
        }
        get {
            guard let selectedCategory = self.previousViewController?.selectedCategory else {return nil}
            return selectedCategory
        }
    }
    
    var categories: [Categories] = []
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        
        self.setUpNavigation()
        
        self.setUpCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIRouter.shared.requestArray(CategoryService.get) { (code: Int?, categories: [Categories]?) in
            guard let categories = categories else {return}
            self.categories = categories
            self.collectionView.reloadData()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for (index, item) in self.categories.enumerated() {
            guard let selectedCategory = self.selectedCategory else {return}
            if item.uuid == selectedCategory.uuid {
                self.collectionView.selectItem(at:  IndexPath(row: index, section: 0),
                                               animated: true,
                                               scrollPosition: .top)
                return
            }
        }
    }
    
    func setUp() {
        self.view.backgroundColor = UIColor.Palette.robinSEgg
    }
    
    func setUpNavigation() {
        self.transparentNavigationBar()
        
        let button = UIButton(type: .custom)
        button.setTitle("카테고리 선택", for: .normal)
        button.titleLabel?.shadowOffset = CGSize(width: 1, height: 1)
        button.titleLabel?.font = UIFont.nanumExtraBold(size: 18)
        button.setTitleShadowColor(.gray, for: .normal)
        button.setImage(UIImage(named: "icWritingFilterUp"), for: .normal)
        button.semanticContentAttribute =
            (UIApplication.shared.userInterfaceLayoutDirection == .rightToLeft ? .forceLeftToRight : .forceRightToLeft)
        button.addTarget(self, action: #selector(categoryButtonDidTap), for: .touchUpInside)
        self.navigationItem.titleView = button
    }
    
    @objc
    func categoryButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setUpCollectionView() {
        self.collectionView.backgroundColor = UIColor(hex: "#f0f0f0")
        self.collectionView.setUp(target: self, cell: FilterCollectionViewCell.self)
        self.collectionView.allowsMultipleSelection = false
        self.collectionView.showsVerticalScrollIndicator = false
    }
    
}
extension WritingFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.reuseIdentifier, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(data: self.categories[indexPath.row])
        cell.setColor(.writing)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = ((collectionView.bounds.width - 51) / 2)
        return CGSize(width: width, height: 122)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let item = collectionView.cellForItem(at: indexPath)
        if item?.isSelected ?? false {
            self.collectionView.deselectItem(at: indexPath, animated: true)
            if self.selectedCategory?.uuid == self.categories[indexPath.row].uuid {
                self.selectedCategory = nil
            }
        } else {
            self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            self.selectedCategory = categories[indexPath.row]
        }
        return false
    }
}
