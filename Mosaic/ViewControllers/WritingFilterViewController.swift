//
//  WritingFilterViewController.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 20..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

typealias Category = (emoji: String, title: String)
class WritingFilterViewController: UIViewController, TransparentNavBarService {

    @IBOutlet weak var collectionView: UICollectionView!
    var previousViewController: WritingViewController?
    var selectedCategory: [Category]? {
        set {
            guard let value = newValue else {return}
            self.previousViewController?.selectedCategory = value
        }
        get {
            guard let selectedCategory = self.previousViewController?.selectedCategory else {return nil}
            return selectedCategory
        }
    }
    
    var categories: [Category] = [
        (emoji: "🤫", title: "익명제보"),
        (emoji: "🏆", title: "공모전"),
        (emoji: "💃", title: "대외활동"),
        (emoji: "✍️", title: "스터디"),
        (emoji: "🍯", title: "대학생활 팁"),
        (emoji: "🙋‍♀️", title: "아르바이트"),
        (emoji: "👫", title: "동아리"),
        (emoji: "👻", title: "아무말")
    ]
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setUp()
        
        self.setUpNavigation()
        
        self.setUpCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        for (index, item) in self.categories.enumerated() {
            if let selectedCategory = self.selectedCategory,
                !selectedCategory.filter({$0.title == item.title}).isEmpty {
                self.collectionView.selectItem(at: IndexPath(row: index, section: 0),
                                               animated: true,
                                               scrollPosition: .top)
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
        self.collectionView.allowsMultipleSelection = true
    }
    
}
extension WritingFilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.reuseIdentifier, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(data: self.categories[indexPath.item])
        cell.setColor(.writing)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 162, height: 122)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 15
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        let item = collectionView.cellForItem(at: indexPath)
        if item?.isSelected ?? false {
            self.collectionView.deselectItem(at: indexPath, animated: true)
        } else {
            self.collectionView.selectItem(at: indexPath, animated: true, scrollPosition: [])
            self.selectedCategory?.append(categories[indexPath.row])
        }
        return false
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        self.selectedCategory = self.selectedCategory?.filter({ $0.title != self.categories[indexPath.row].title })
    }
}
