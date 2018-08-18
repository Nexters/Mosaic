//
//  FilterViewController.swift
//  Mosaic
//
//  Created by Zedd on 2018. 8. 18..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController {

    @IBOutlet weak var collectionView: UICollectionView!
    
    static func create() -> FilterViewController? {
        return UIStoryboard(name: "Filter", bundle: nil).instantiateViewController(withIdentifier: classNameToString) as? FilterViewController
    }
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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupNavigation()
        
        self.setupCollectionView()
        
        self.setupBackgroundView()
    }
    
    func setupNavigation() {
        self.navigationController?.navigationBar.tintColor = UIColor.red
    }
    
    func setupBackgroundView() {
        self.collectionView.backgroundColor = UIColor(hex: "#f0f0f0")
    }
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        let xib = UINib(nibName: "FilterCollectionViewCell", bundle: nil)
        self.collectionView.register(xib, forCellWithReuseIdentifier: FilterCollectionViewCell.reuseIdentifier)
        
    }

}
extension FilterViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: FilterCollectionViewCell.reuseIdentifier, for: indexPath) as? FilterCollectionViewCell else { return UICollectionViewCell() }
        cell.configure(data: self.typeTuple[indexPath.item])
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
        }
        return false
    }
    
}
class FilterCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var highlightView: UIView!
    
    override var isSelected: Bool{
        didSet{
            self.highlightView.backgroundColor = isSelected ? UIColor.red : UIColor(hex: "#ccf6ff")
        }
    }
    override func awakeFromNib() {
        self.highlightView.backgroundColor = UIColor(hex: "#ccf6ff")
        self.titleLabel.font = UIFont.nanumExtraBold(size: 14)
        
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(data: (emoji: String, title: String)) {
        self.emojiLabel.text = data.emoji
        self.titleLabel.text = data.title
    }

}
