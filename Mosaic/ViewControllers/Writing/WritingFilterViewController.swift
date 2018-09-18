//
//  WritingFilterViewController.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 20..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

protocol FilterViewDataSource {
    var selectedCategories: [Categories] {set get}
}

class WritingFilterViewController: UIViewController, TransparentNavBarService {

    @IBOutlet weak var collectionView: UICollectionView!
//    var previousViewController: WritingViewController?
//    var selectedCategory: Categories? {
//        set {
//            self.previousViewController?.selectedCategory = newValue
//        }
//        get {
//            guard let selectedCategory = self.previousViewController?.selectedCategory else {return nil}
//            return selectedCategory
//        }
//    }
    
    var dataSource: FilterViewDataSource?
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
            guard let code = code else {return}
            switch code {
            case 200:
                guard let categories = categories else {return}
                self.categories = categories
                self.collectionView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    guard let selectedCategory = self.dataSource?.selectedCategories.first else {return}
                    self.select(selectedCategory, self.categories)
                })
            default:
                break
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
    
    func select(_ category: Categories,_ categories: [Categories]) {
        for (index, item) in categories.enumerated() {
            let indexPath = IndexPath(row: index, section: 0)
            if item.uuid == category.uuid,
                self.collectionView.cellForItem(at: indexPath) != nil {
                self.collectionView.selectItem(at:  indexPath,
                                               animated: true,
                                               scrollPosition: .top)
                return
            }
        }
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
            if let selectedCategory = self.dataSource?.selectedCategories.first,
                selectedCategory.uuid == self.categories[indexPath.row].uuid {
                self.dataSource?.selectedCategories = []
            }
        } else {
            self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            self.dataSource?.selectedCategories = [categories[indexPath.row]]
        }
        return false
    }
}
