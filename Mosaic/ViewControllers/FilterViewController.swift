//
//  FilterViewController.swift
//  Mosaic
//
//  Created by Zedd on 2018. 8. 18..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit
//protocol FilterDataSource {
//    var categories: [String: String] { get set }
//}
class FilterViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!

    
    static func create() -> FilterViewController? {
        return UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: classNameToString) as? FilterViewController
    }
    var categories: [Categories] = []
    
    var typeTuple: [(emoji: String, title: String)] = [
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
        
        self.setupNavigation()
        
        self.setupCollectionView()
        
        self.setupBackgroundView()
        
        ApiManager.shared.requestCategories { (code, categories) in
            self.categories = categories ?? []
            self.collectionView.reloadData()
        }
        
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.barTintColor = ColorPalette.background
        self.navigationController?.navigationBar.isTranslucent = false

        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icSearchClose"), style: .plain, target: self, action: #selector(colseButtonDidTap))
       
        self.title = "관심분야"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.white]
    }
    
    @objc
    func colseButtonDidTap() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func setupBackgroundView() {
        self.collectionView.backgroundColor = UIColor(hex: "#f0f0f0")
    }
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let xib = UINib(nibName: "FilterCollectionViewCell", bundle: nil)
        self.collectionView.register(xib, forCellWithReuseIdentifier: FilterCollectionViewCell.reuseIdentifier)
        self.collectionView.allowsMultipleSelection = true
    }

}
extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.reuseIdentifier, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(data: self.categories[indexPath.item])
        cell.setColor(.home)
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
            //self.categories.updateValue(self.typ, forKey: "categories")
        }
        return false
    }
    
}

enum FilterType {
    case home, writing
}

class FilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var highlightView: UIView!
    var selectedBackgroundColor: UIColor = UIColor(hex: "#fc543a")
    var deselectedBackgroundColor: UIColor = .white
    
    override var isSelected: Bool{
        didSet{
            self.highlightView.backgroundColor = isSelected ? .clear : UIColor(hex: "#ccf6ff")
            self.backgroundColor = isSelected ? self.selectedBackgroundColor : self.deselectedBackgroundColor
            self.titleLabel.textColor = isSelected ? .white : .black
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()

        self.highlightView.backgroundColor = UIColor(hex: "#ccf6ff")
        self.titleLabel.font = UIFont.nanumExtraBold(size: 14)
        self.layer.cornerRadius = 2
        self.backgroundColor = .white
        
        self.layer.shadowColor = UIColor(hex: "#c2c2c2").cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 0.0)
        self.layer.shadowRadius = 20
        self.layer.shadowOpacity = 0.2
        self.layer.masksToBounds = false
        self.layer.shadowPath = UIBezierPath(roundedRect: self.bounds, cornerRadius: 0).cgPath
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(data: Categories) {
        self.emojiLabel.text = data.emoji
        self.titleLabel.text = data.name
    }
    
    func setColor(_ type: FilterType) {
        switch type {
        case .home:
            self.selectedBackgroundColor = UIColor(hex: "#fc543a")
            self.deselectedBackgroundColor = .white
        case .writing:
            self.selectedBackgroundColor = UIColor.Palette.robinSEgg
            self.deselectedBackgroundColor = .white
        }
    }
}
