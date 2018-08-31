//
//  PagingImageCollectionView.swift
//  Mosaic
//
//  Created by 이광용 on 2018. 8. 24..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

class PagingImageCollectionView: UIView {
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    let pageControlBackgroundLayer = CALayer()
    var imageURLs = [String]() {
        didSet {
            self.pageControl.numberOfPages = imageURLs.count
            self.collectionView.reloadData()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setUpView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updatePageControlBackgrounLayer()
    }
    
    private func setUpView() {
        Bundle.main.loadNibNamed(PagingImageCollectionView.reuseIdentifier, owner: self, options: nil)
        addSubview(self.contentView)
        
        self.contentView.frame = self.bounds
        self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        
        self.collectionView.isPagingEnabled = true
        self.collectionView.setUp(target: self, cell: ImageCollectionViewCell.self)
        self.collectionView.showsHorizontalScrollIndicator = false
        self.collectionView.alwaysBounceHorizontal = false
        self.collectionView.alwaysBounceVertical = false
        
        self.pageControlBackgroundLayer.backgroundColor = UIColor.black.withAlphaComponent(0.3).cgColor
        self.pageControl.layer.addSublayer(self.pageControlBackgroundLayer)
    }
    
    func updatePageControlBackgrounLayer() {
        let height: CGFloat = 20
        let margin: CGFloat = 10
        let bounds = self.pageControl.bounds
        self.pageControlBackgroundLayer.frame = CGRect(x: -margin, y: bounds.height / 2 - margin, width: bounds.width + margin * 2, height: height)
        self.pageControlBackgroundLayer.cornerRadius = height/2
    }
    
}

extension PagingImageCollectionView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.imageURLs.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: ImageCollectionViewCell = collectionView.dequeueReusableCell(forIndexPath: indexPath)
        cell.thumbnail.kf.setImage(with: URL(string: self.imageURLs[indexPath.row]))
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let rect = collectionView.bounds
        return CGSize(width: rect.width, height: rect.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        //Horiznotal Card Paging
        if scrollView is UICollectionView {
            let width = self.collectionView.bounds.width
            let pageWidth: Float = Float(width) //(Paging Item Size) + (Minimum spacing)
            
            let currentOffset: Float = Float(scrollView.contentOffset.x)
            let targetOffset: Float = Float(targetContentOffset.pointee.x)
            var newTargetOffset: Float = 0
            if targetOffset > currentOffset {
                newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth
            }
            else {
                newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth
            }
            if newTargetOffset < 0 {
                newTargetOffset = 0
            }
            else if (newTargetOffset > Float(scrollView.contentSize.width)){
                newTargetOffset = Float(Float(scrollView.contentSize.width))
            }
            
            targetContentOffset.pointee.x = CGFloat(currentOffset)
            scrollView.setContentOffset(CGPoint(x: CGFloat(newTargetOffset), y: scrollView.contentOffset.y), animated: true)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView is UICollectionView {
            let visibleRect = CGRect(origin: collectionView.contentOffset, size: collectionView.bounds.size)
            let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
            guard let indexPath = self.collectionView.indexPathForItem(at: visiblePoint) else {return}
            self.pageControl.currentPage = indexPath.row
        }
        
    }
}


