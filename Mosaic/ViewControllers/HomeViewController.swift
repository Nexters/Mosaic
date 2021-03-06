//
//  HomeViewController.swift
//  Mosaic_iOS
//
//  Created by Zedd on 2018. 7. 28..
//  Copyright © 2018년 Zedd. All rights reserved.
//

import UIKit
enum ColorPalette {
    static let background = UIColor(hex: "#ff573dz")
    static let searchView = UIColor(hex: "#e62f12")
}

class HomeViewController: UIViewController, HomeDelegate, FilterDataSource {
    
    @IBOutlet weak var searchView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    var articles: [Article]?
    var categories: [String: String] = [:]
    var requestCategories: [[String : String]] = [[:]]

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    static func create() -> HomeViewController? {
        return UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: classNameToString) as? HomeViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupCollectionView()
    
        self.setupNavigation()
        
        self.setupSearchBar()
        
        self.view.backgroundColor = ColorPalette.background
        
        self.setNeedsStatusBarAppearanceUpdate()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        APIRouter.shared.requestArray(ArticleService.getAll(category: self.requestCategories)) { (code: Int?, articles: [Article]?) in
            if code == 200 {
                self.articles = articles
                self.collectionView.reloadData()
            }
        }
    }
    
    func setupCollectionView() {
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        
        self.collectionView.isPagingEnabled = true
        self.collectionView.showsHorizontalScrollIndicator = false
        
        self.collectionView.backgroundColor = .clear
        self.collectionView.layer.cornerRadius = 2
    }
    
    @objc
    func setupNavigation() {
        let logo = UIImage(named: "icLogotype")
        let imageView = UIImageView(image:logo)
        self.navigationItem.titleView = imageView
        
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(named: "icMy"), style: .plain, target: self, action: #selector(myPageButtonDidTap))
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "icFilter"), style: .plain, target: self, action: #selector(filterButtonDidTap))
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        
        self.navigationController?.navigationBar.barTintColor = ColorPalette.background
        
        self.navigationController?.navigationBar.clipsToBounds = true

    }
    
    @objc
    func myPageButtonDidTap() {
        guard let viewController = MyPageViewController.create() else { return }
        self.navigationController?.pushViewController(viewController, animated: true)
        
    }
    
    @objc
    func filterButtonDidTap() {
        guard let viewController = FilterViewController.create() else { return }
        viewController.datasource = self
        let navigation = UINavigationController(rootViewController: viewController)
        self.present(navigation, animated: true, completion: nil)
    }
    
    func setupSearchBar() {
        self.searchView.backgroundColor = ColorPalette.searchView
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(searchBarViewDidTap))
        self.searchView.addGestureRecognizer(tapGestureRecognizer)
        self.searchView.layer.cornerRadius = 2
    }
    
    @objc
    func searchBarViewDidTap() {
        guard let viewController = SearchViewController.create() else { return }
        let navigation = UINavigationController(rootViewController: viewController)
        self.present(navigation, animated: false, completion: nil)
    }
    
    @IBAction func writeButtonDidTap(_ sender: UIButton) {
        guard let viewController = WritingViewController.create(storyboard: "Writing") as? WritingViewController else {return}
        let navigation = UINavigationController(rootViewController: viewController)
        self.present(navigation, animated: true, completion: nil)
    }
    
    func goToComment() {
        //FIXME: -
    }
    
    func bookmarkButtondDidTap(cell: HomeCollectionViewCell, isScraped: Bool) {
        guard let indexPath = self.collectionView.indexPath(for: cell) else { return }
        ApiManager.shared.updateBookMark(type: isScraped ? .delete : .add, article: self.articles![indexPath.item]) { (code, article) in
            if code == 200 {
                print(article as? Article)
            } else {
                // do nothing.
            }
        }
    }
}

extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.articles?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: HomeCollectionViewCell.reuseIdentifier, for: indexPath) as! HomeCollectionViewCell
        cell.configure(article: self.articles?[indexPath.row])
        cell.delegate = self
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let articles = self.articles else {return}
        let article = articles[indexPath.row]
        guard let viewController = DetailViewController.create(storyboard: "Detail") as? DetailViewController else {return}
        viewController.article = article
        let navigation = UINavigationController(rootViewController: viewController)
        self.present(navigation, animated: true, completion: nil)
    }
    
}

open class CardsCollectionViewLayout: UICollectionViewLayout {
    
    // MARK: - Layout configuration
    public var itemSize: CGSize = CGSize(width: UIScreen.main.bounds.width - 36, height: 400) {
        didSet{
            invalidateLayout()
        }
    }
    
    public var spacing: CGFloat = 10.0 {
        didSet{
            invalidateLayout()
        }
    }
    
    public var maximumVisibleItems: Int = 4 {
        didSet{
            invalidateLayout()
        }
    }
    
    // MARK: UICollectionViewLayout
    
    override open var collectionView: UICollectionView {
        return super.collectionView!
    }
    
    override open var collectionViewContentSize: CGSize {
        let itemsCount = CGFloat(collectionView.numberOfItems(inSection: 0))
        return CGSize(width: collectionView.bounds.width * itemsCount,
                      height: collectionView.bounds.height)
    }
    
    override open func prepare() {
        super.prepare()
        assert(collectionView.numberOfSections == 1, "Multiple sections aren't supported!")
    }
    
    override open func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        let totalItemsCount = collectionView.numberOfItems(inSection: 0)
        
        let minVisibleIndex = max(Int(collectionView.contentOffset.x) / Int(collectionView.bounds.width), 0)
        let maxVisibleIndex = min(minVisibleIndex + maximumVisibleItems, totalItemsCount)
        
        let contentCenterX = collectionView.contentOffset.x + (collectionView.bounds.width / 2.0)
        
        let deltaOffset = Int(collectionView.contentOffset.x) % Int(collectionView.bounds.width)
        
        let percentageDeltaOffset = CGFloat(deltaOffset) / collectionView.bounds.width
        
        let visibleIndices = stride(from: minVisibleIndex, to: maxVisibleIndex, by: 1)
        
        let attributes: [UICollectionViewLayoutAttributes] = visibleIndices.map { index in
            let indexPath = IndexPath(item: index, section: 0)
            return computeLayoutAttributesForItem(indexPath: indexPath,
                                                  minVisibleIndex: minVisibleIndex,
                                                  contentCenterX: contentCenterX,
                                                  deltaOffset: CGFloat(deltaOffset),
                                                  percentageDeltaOffset: percentageDeltaOffset)
        }
        
        return attributes
    }
    
    override open func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        let contentCenterX = collectionView.contentOffset.x + (collectionView.bounds.width / 2.0)
        let minVisibleIndex = Int(collectionView.contentOffset.x) / Int(collectionView.bounds.width)
        let deltaOffset = Int(collectionView.contentOffset.x) % Int(collectionView.bounds.width)
        let percentageDeltaOffset = CGFloat(deltaOffset) / collectionView.bounds.width
        return computeLayoutAttributesForItem(indexPath: indexPath,
                                              minVisibleIndex: minVisibleIndex,
                                              contentCenterX: contentCenterX,
                                              deltaOffset: CGFloat(deltaOffset),
                                              percentageDeltaOffset: percentageDeltaOffset)
    }
    
    override open func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}


// MARK: - Layout computations

fileprivate extension CardsCollectionViewLayout {
    
    private func scale(at index: Int) -> CGFloat {
        let translatedCoefficient = CGFloat(index) - CGFloat(self.maximumVisibleItems) / 2
        return CGFloat(pow(0.95, translatedCoefficient))
    }
    
    private func transform(atCurrentVisibleIndex visibleIndex: Int, percentageOffset: CGFloat) -> CGAffineTransform {
        var rawScale = visibleIndex < maximumVisibleItems ? scale(at: visibleIndex) : 1.0
        
        if visibleIndex != 0 {
            let previousScale = scale(at: visibleIndex - 1)
            let delta = (previousScale - rawScale) * percentageOffset
            rawScale += delta
        }
        return CGAffineTransform(scaleX: rawScale, y: rawScale)
    }
    
    fileprivate func computeLayoutAttributesForItem(indexPath: IndexPath,
                                                    minVisibleIndex: Int,
                                                    contentCenterX: CGFloat,
                                                    deltaOffset: CGFloat,
                                                    percentageDeltaOffset: CGFloat) -> UICollectionViewLayoutAttributes {
        let attributes = UICollectionViewLayoutAttributes(forCellWith:indexPath)
        let visibleIndex = indexPath.row - minVisibleIndex
        attributes.size = itemSize
        let midY = self.collectionView.bounds.midY
        attributes.center = CGPoint(x: contentCenterX + spacing * CGFloat(visibleIndex),
                                    y: midY + spacing * CGFloat(visibleIndex))
        attributes.zIndex = maximumVisibleItems - visibleIndex
        
        attributes.transform = transform(atCurrentVisibleIndex: visibleIndex,
                                         percentageOffset: percentageDeltaOffset)
        switch visibleIndex {
        case 0:
            attributes.center.x -= deltaOffset
            break
        case 1..<maximumVisibleItems:
            attributes.center.x -= spacing * percentageDeltaOffset
            attributes.center.y -= spacing * percentageDeltaOffset
            
            
            if visibleIndex == maximumVisibleItems - 1 {
                attributes.alpha = percentageDeltaOffset
            }
            break
        default:
            attributes.alpha = 0
            break
        }
        return attributes
    }
}

