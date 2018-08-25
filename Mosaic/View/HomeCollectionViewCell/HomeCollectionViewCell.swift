//
//  HomeCollectionViewCell.swift
//
//
//  Created by Zedd on 2018. 8. 8..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit
extension ColorPalette {
    static let collegeContainer = UIColor(hex: "#2d3253")
    static let bookmarkContainer = UIColor(hex: "#ff573d")
    static let subText = UIColor(hex: "#abafb4")
    static let description = UIColor(hex: "#474747")
}

protocol HomeDelegate {
    func goToComment()
    func bookmarkButtondDidTap(cell: HomeCollectionViewCell, isScraped: Bool)
}
class HomeCollectionViewCell: UICollectionViewCell {

    var fommater: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일"
        return formatter
    }
    
    @IBOutlet weak var imageCollectionViewWidth: NSLayoutConstraint!
    @IBOutlet weak var imageCollectionView: UICollectionView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    @IBOutlet weak var descriptionLabelHeight: NSLayoutConstraint!
    @IBOutlet weak var typeView: UIView!
    @IBOutlet weak var commentContainerView: UIView!
    @IBOutlet weak var collegeImageView: UIImageView!
    @IBOutlet weak var collegeNameLabel: UILabel!
    
    @IBOutlet weak var commentImageView: UIImageView!
    @IBOutlet weak var commentLabel: UILabel!
    
    @IBOutlet weak var imageCollectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var bookMarkContainerView: UIView!
    @IBOutlet weak var bookMarkImageView: UIImageView!
    @IBOutlet weak var bookMarkLabel: UILabel!
    
    @IBOutlet weak var lineView: UIView!
    var delegate: HomeDelegate?
    
    var imageUrls: [String] = []
    var article: Article?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.setupTopView()
        self.setupBottomView()
        
        self.backgroundColor = .white
        self.layer.borderWidth = 0.5
        self.layer.borderColor = UIColor(hex: "#dddddd").cgColor
        
        self.layer.cornerRadius = 2
        self.lineView.backgroundColor = UIColor(hex: "#dbdbdb")
        
        let commentGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(commentDidTap))
        self.commentContainerView.isUserInteractionEnabled = true
        let bookMarkGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(bookMarkDidTap))
        self.bookMarkContainerView.isUserInteractionEnabled = true
        self.commentContainerView.addGestureRecognizer(commentGestureRecognizer)
        self.bookMarkContainerView.addGestureRecognizer(bookMarkGestureRecognizer)
    }
    override func prepareForReuse() {
        self.setupCollectioView()
    }
    
    func setupTopView() {
        self.setupTopLabels()
        let typeView = TypeView.create(frame: self.typeView.bounds)
        typeView.setup()
        typeView.configure(title: "공모전🏆")
        self.typeView.addSubview(typeView)
        self.setupCollectioView()
        
    }
    
    func setupTopLabels() {
        self.timeLabel.font = UIFont.nanumBold(size: 12)
        self.timeLabel.textColor = ColorPalette.subText
        
    }
    
    func setupBottomView() {
        self.setupContainerViews()
        self.setupBottomeLabels()
    }
    
    func setupContainerViews() {
        self.commentContainerView.backgroundColor = ColorPalette.collegeContainer
        self.bookMarkContainerView.backgroundColor = ColorPalette.bookmarkContainer
        
        self.commentContainerView.layer.cornerRadius = 2
        self.bookMarkContainerView.layer.cornerRadius = 2
    }
    
    func setupCollectioView() {
        self.imageCollectionView.delegate = self
        self.imageCollectionView.dataSource = self
    }
    
    func setupBottomeLabels() {

    }
    
    
    func configure(article: Article?) {
        guard let article = article else { return }
        self.article = article
        let attribute: [NSAttributedStringKey: Any] = [
            .font: UIFont.nanumBold(size: 10),
            .foregroundColor: ColorPalette.subText
        ]
        self.collegeNameLabel.attributedText = NSAttributedString(string: article.writer?.nickName ?? "", attributes: attribute)
        self.commentLabel.attributedText = NSAttributedString(string: "댓글 \(article.replies)", attributes: attribute)
        self.bookMarkLabel.attributedText = NSAttributedString(string: "스크랩", attributes: attribute)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 7
        paragraphStyle.alignment = .center
        let descriptionAttributes: [NSAttributedStringKey: Any] = [
            .font: UIFont.nanumRegular(size: 16),
            .foregroundColor: ColorPalette.description,
            .paragraphStyle: paragraphStyle,
            .kern: -1
        ]
        
        self.descriptionLabel.attributedText = NSAttributedString(string: article.content ?? "", attributes: descriptionAttributes)
        self.imageUrls = article.imageUrls ?? []

        if article.imageUrls?.isEmpty == true {
            self.descriptionLabelHeight.constant = 160
            self.imageCollectionViewHeight.constant = 0
            self.imageCollectionView.reloadData()

        } else {
            self.descriptionLabelHeight.constant = 124
            self.imageCollectionViewHeight.constant = 40
            self.imageCollectionView.reloadData()
        }
        self.imageCollectionViewWidth.constant = CGFloat(min(3, self.imageUrls.count) * 40) + ((self.imageUrls.count == 2) ? 6 : 12)
        
        self.commentContainerView.backgroundColor = article.replies > 0 ? ColorPalette.collegeContainer : UIColor(hex: "#b3b3b3")
        self.bookMarkContainerView.backgroundColor = article.isScraped ? ColorPalette.bookmarkContainer : UIColor(hex: "#b3b3b3")
        guard let imageUrlStr = article.writer?.university?.imageUrl else { return }
        let url = URL(string: imageUrlStr)
        self.collegeImageView.kf.setImage(with: url)
        
        let df = DateFormatter()
        df.dateFormat = "M월 d일"
        let now = df.string(from: Date(milliseconds: article.createdAt))
        self.timeLabel.text = "\(now)"
        
        let calendar = Calendar.current
        let myDate = Date(milliseconds: article.createdAt)
        print(calendar.isDateInYesterday(myDate))
        print(calendar.isDateInToday(myDate))

    }
    
    @objc
    func commentDidTap() {
        self.delegate?.goToComment()
    }
    
    @objc
    func bookMarkDidTap() {
        self.bookMarkContainerView.backgroundColor = self.article?.isScraped == true ? UIColor(hex: "#b3b3b3") : ColorPalette.bookmarkContainer
        self.delegate?.bookmarkButtondDidTap(cell: self, isScraped: self.article?.isScraped ?? false)
        self.article?.isScraped = !(self.article?.isScraped)!
        
        
    }
}
extension HomeCollectionViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return min(3, self.imageUrls.count)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeImageCollectionViewCell.reuseIdentifier, for: indexPath) as? HomeImageCollectionViewCell else { return UICollectionViewCell() }
        if indexPath.item == 2 && self.imageUrls.count > 3{
            cell.configure(urls: self.imageUrls[indexPath.row], isBlured: true, count: self.imageUrls.count - 3)
        } else {
             cell.configure(urls: self.imageUrls[indexPath.row])
        }

        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 40, height: 40)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 6
    }
}
class HomeImageCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var blurView: UIVisualEffectView!
    @IBOutlet weak var articleImageView: UIImageView!
    
    override func awakeFromNib() {
        self.blurView.isHidden = true
        self.countLabel.isHidden = true
        self.layer.cornerRadius = 2
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
    }
    
    func configure(urls: String, isBlured: Bool = false, count: Int = 0) {
        let url = URL(string: urls)
        self.articleImageView.kf.setImage(with: url)
        
        if isBlured {
            self.blurView.isHidden = false
            self.countLabel.isHidden = false
            self.countLabel.text = "+\(count)"
        } else {
            self.blurView.isHidden = true
            self.countLabel.isHidden = true
        }
    }
}

extension Date {
    var millisecondsSince1970:Int {
        return Int((self.timeIntervalSince1970 * 1000.0).rounded())
    }
    
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds) / 1000)
    }
}
