//
//  AccessoryView.swift
//  Mosaic_iOS
//
//  Created by 이광용 on 2018. 7. 25..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit

enum AccessoryType {
    case writing, comment
}
protocol AccessoryViewDelegate {
    func accessoryView(_ view: AccessoryView)
}
extension AccessoryViewDelegate where Self: UICollectionViewDelegate & UICollectionViewDataSource {
}
class AccessoryView: UIView {
    @IBOutlet weak private var contentView: UIView!
    @IBOutlet weak private var imageButton: UIButton!
    @IBOutlet weak private var textContainerView: UIView!
    @IBOutlet weak private var textfield: UITextField!
    @IBOutlet weak private var sendButton: UIButton!
    @IBOutlet weak private var collectionView: UICollectionView!
    
    static var height: CGFloat = 44.0
    var delegate: AccessoryViewDelegate?
    
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
    }
    
    func addTarget(_ target: Any?, selector: Selector) {
        self.imageButton.addTarget(target, action: selector, for: .touchUpInside)
    }
    
    func setContentViewBackgroundColor(_ color: UIColor?) {
        self.contentView.backgroundColor = color
    }
    
    func setUp(_ type: AccessoryType, delegate: AccessoryViewDelegate? = nil) {
        self.delegate = delegate
        switch type {
        case .writing :
            self.textContainerView.isHidden = true
            self.collectionView.isHidden = false
            if let delegate = self.delegate as? UICollectionViewDelegate & UICollectionViewDataSource {
                self.collectionView.setUp(target: delegate, cell: ImageCollectionViewCell.self)
            }
        case .comment :
            self.textContainerView.isHidden = false
            self.collectionView.isHidden = true
        }
    }
    
    func reloadCollectionView() {
        self.collectionView.reloadData()
    }
}

