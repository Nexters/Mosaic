//
//  AccessoryView.swift
//  Mosaic_iOS
//
//  Created by 이광용 on 2018. 7. 25..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit
import TLPhotoPicker

class AccessoryView: UIView {
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var imageButton: UIButton!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    var selectedAssets = [TLPHAsset]()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }

    private func setUpView() {
        Bundle.main.loadNibNamed(AccessoryView.reuseIdentifier, owner: self, options: nil)
        addSubview(self.contentView)
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.collectionView.transform = CGAffineTransform(scaleX: -1, y: 1)
        self.collectionView.setUp(target: self,
                                  cell: ImageCollectionViewCell.self)
    }
    
    func addTarget(_ target: Any?, selector: Selector) {
        self.imageButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    
    func setContentViewBackgroundColor(_ color: UIColor?) {
        self.contentView.backgroundColor = color
    }
    
    func reloadCollectionView() {
        self.collectionView.reloadData()
    }
}

//MARK: UICOLLECTIONVIEWDELEGATE, UICOLLECTIONVIEWDATASOURCE
extension AccessoryView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.selectedAssets.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.setUpUI()
        let asset = self.selectedAssets[indexPath.row]
        if let image = asset.fullResolutionImage {
            cell.image = image
        }else {
            print("Can't get image at local storage, try download image")
            asset.cloudImageDownload(progressBlock: { (progress) in
                DispatchQueue.main.async {
                    cell.label.text = "\(100*progress)%"
                }
            }, completionBlock: { (image) in
                if let image = image {
                    DispatchQueue.main.async {
                        cell.image = image
                        cell.label.isHidden = true
                    }
                }
            })
        }
        cell.transform = CGAffineTransform(scaleX: -1, y: 1)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 28, height: 28)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}
