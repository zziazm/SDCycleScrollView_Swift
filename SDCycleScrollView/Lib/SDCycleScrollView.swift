//
//  SDCycleScrollView.swift
//  SDCycleScrollView
//
//  Created by zm on 2017/6/9.
//  Copyright © 2017年 zm. All rights reserved.
//

import UIKit

typealias CallBack = (_ cycleScrollView:SDCycleScrollView, _ index: Int) -> Void

private let rate = 100
private let ID = "cycleCell"

protocol SDCycleScrollViewDelegate: class {
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView, didSelectItemAt index: Int)
}

enum SDCycleScrollViewPageContolAliment {
    case AlimentRight, AlimentCenter
}

enum SDCycleScrollViewPageContolStyle {
    case StyleClassic,StyleNone
}

class SDCycleScrollView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    var titleLabelBackgroundColor:UIColor?
    var titleLabelHeight:CGFloat = 30.0
    var titleLabelTextAlignment: NSTextAlignment = .left
    var titleLabelTextColor: UIColor = UIColor.white
    var titleLabelTextFont: UIFont = UIFont.systemFont(ofSize: 14)
    var bannerImageViewContentMode: UIViewContentMode = .scaleToFill
    var titlesGroup: [String]?{
        didSet{
            if let titles = titlesGroup {
                if  onlyDisplayText{
                    var tem = [String]()
                    for _ in 0..<titles.count {
                        tem.append("")
                    }
                    self.backgroundColor = UIColor.clear
                    self.imageURLStringsGroup = tem
                }
            }
        }
    }
    var autoScroll: Bool = true{
        didSet{
            self.invalidateTimer()
            if autoScroll {
                self.setupTimer()
            }
        }
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
    var scrollDirection: UICollectionViewScrollDirection = .horizontal {
        didSet{
            flowLayout?.scrollDirection = scrollDirection;
        }
    }
    var pageControlStyle: SDCycleScrollViewPageContolStyle = .StyleClassic
    weak var delegate: SDCycleScrollViewDelegate?
    var clickItemOperationBlock: CallBack?
    var onlyDisplayText: Bool = false
    var currentPageDotColor: UIColor?{
        get {
           return self.pageControl?.currentPageIndicatorTintColor
        }
        set{
            self.pageControl?.currentPageIndicatorTintColor = newValue
        }
    }
    
    var pageDotColor: UIColor?{
        get{
            return self.pageControl?.pageIndicatorTintColor
        }
        set{
            self.pageControl?.currentPageIndicatorTintColor = newValue
        }
    }
    var pageControlAliment = SDCycleScrollViewPageContolAliment.AlimentCenter
    var showPageControl: Bool = true {
        didSet{
            self.pageControl?.isHidden = !showPageControl
        }
    }
    var pageControlDotSize = CGSize(width: 10.0, height: 10.0)
    var pageControlBottomOffset: CGFloat = 0.0
    var pageControlRightOffset: CGFloat = 0.0
    var pageControl: UIPageControl?
    var timer: Timer?
    var totalItemCount: Int = 0
    var infiniteLoop: Bool = true
    var autoScrollTimeInterval: TimeInterval = 2
    var localizationImageNamesGroup: [String]?{
        didSet{
            self.imagePathsGroup = localizationImageNamesGroup
        }
    }
    var imagePathsGroup: [String]?{
        didSet{
            self.setupImagePathsGroup()
        }
    }
    
    func setupImagePathsGroup() {
        self.invalidateTimer()
        if let array = imagePathsGroup {
            totalItemCount = infiniteLoop ? array.count * rate : array.count
            if array.count != 1 {
                mainView?.isScrollEnabled = true
                if autoScroll {
                    self.setupTimer()
                }
            }else{
                mainView?.isScrollEnabled = false
            }
            
        }
        self.setupPageControl()
        self.mainView?.reloadData()
    }
    
    var imageURLStringsGroup: [String]?{
//        get{
//            return self.imageURLStringsGroup
//        }
//        set{
//            self.imagePathsGroup = newValue
//        }
        didSet{
            imagePathsGroup = imageURLStringsGroup
        }
        
        
    }
    var backgroundImageView: UIImageView?
    var placeholderImage: UIImage?{
        didSet{
        self.setupPlaceholderImage()
        }
    }
    func setupPlaceholderImage() {
        if let image = placeholderImage {
            self.setupBackgroundImageView(image:image)
        }
    }
    
    func setupBackgroundImageView(image: UIImage?)  {
        if self.backgroundImageView == nil {
            backgroundImageView = UIImageView()
            backgroundImageView?.contentMode = .scaleAspectFit
            self .insertSubview(backgroundImageView!, belowSubview: mainView!)
            
        }
        self.backgroundImageView?.image = image
    }
    var flowLayout: UICollectionViewFlowLayout?
    var mainView: UICollectionView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupMainView()

    }
    
    convenience init(frame: CGRect, placeholderImage: UIImage?) {
        self.init(frame: frame)
        self.placeholderImage = placeholderImage
        self.setupPlaceholderImage()
        self.initialization()
    }
    
    convenience init(frame: CGRect, shouldInfiniteLoop: Bool, imageNamesGroup:[String]) {
        self.init(frame:frame)
        self.infiniteLoop = shouldInfiniteLoop
        self.localizationImageNamesGroup = imagePathsGroup
        self.imagePathsGroup = imageNamesGroup
        self.setupMainView()
        self.setupImagePathsGroup()
        
    }
    
    convenience init(frame: CGRect, delegate: SDCycleScrollViewDelegate? , placeholderImage: UIImage?) {
        self.init(frame: frame)
        self.delegate = delegate
        self.placeholderImage = placeholderImage
        self.setupPlaceholderImage()
        self.setupBackgroundImageView(image: placeholderImage)
    }
    
    func initialization() {
    }
    func setupPageControl() {
        if (pageControl != nil) {
            pageControl?.removeFromSuperview()
        }
        
        if self.imagePathsGroup?.count == 0 || self.imagePathsGroup?.count == 1 {
            return
        }
        let indexOnPageControl = self.pageControlIndexWithCurrentCellIndex(index: self.currentIndex())
        pageControl = UIPageControl()
        pageControl?.numberOfPages = (self.imagePathsGroup?.count)!
        pageControl?.isUserInteractionEnabled = false
        pageControl?.currentPage = indexOnPageControl
        self.addSubview(pageControl!)
    }
    
    func pageControlIndexWithCurrentCellIndex(index: Int) -> Int {
        return (index % (imagePathsGroup?.count)!)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMainView()  {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = scrollDirection
        self.flowLayout = flowLayout
        let mainView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        mainView.backgroundColor = UIColor.clear
        mainView.isPagingEnabled = true
        mainView.showsVerticalScrollIndicator = false
        mainView .register(SDCollectionViewCell.self, forCellWithReuseIdentifier: ID)
        mainView.delegate = self
        mainView.dataSource = self
        mainView.scrollsToTop = false
        self.addSubview(mainView)
        self.mainView = mainView
        
    }
    
    func setupTimer ()  {
//        timer = Timer(timeInterval: autoScrollTimeInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
//        RunLoop.current.add(timer!, forMode:.commonModes)
    }
    
    func currentIndex() -> Int {
        var index = 0
        switch scrollDirection {
        case .horizontal:
            index = Int ( ((mainView?.contentOffset.x)! + (flowLayout?.itemSize.width)! / 2.0) / (flowLayout?.itemSize.width)!)

        default:
            index = Int (((mainView?.contentOffset.y)! + (flowLayout?.itemSize.height)!/2 ) / (flowLayout?.itemSize.height)!)
        }
        print("aaaaaaaaaaaaaaaaaaaaa\(index)")
        return index
    }
    
    func scrollToIndex(targetIndex:Int) {
        if !infiniteLoop && targetIndex >= totalItemCount{
            return
        }
        var scrollPositon: UICollectionViewScrollPosition = .centeredHorizontally
        if scrollDirection == .horizontal {
            scrollPositon = .centeredHorizontally
        } else {
            scrollPositon = .centeredVertically
        }
        
        mainView?.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at:scrollPositon, animated: true)
    }
    
    func automaticScroll() {
        let currentIndex = self.currentIndex()
        let targetIndex = currentIndex + 1
        self.scrollToIndex(targetIndex: targetIndex)
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return totalItemCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath)
        if let collectionCell = cell as? SDCollectionViewCell  {
            let itemIndex = self.pageControlIndexWithCurrentCellIndex(index: indexPath.row)
            let imagePath = self.imagePathsGroup?[itemIndex]
            if !onlyDisplayText {
                if let temImagePath = imagePath {
                    if  temImagePath.hasPrefix("http"){
                        collectionCell.imageView.af_setImage(withURL: URL(string: temImagePath)!, placeholderImage: self.placeholderImage, filter: nil, progress: nil , progressQueue: DispatchQueue.main, imageTransition: .noTransition, runImageTransitionIfCached: false, completion: nil)
                    }else{
                        var  image = UIImage(named: temImagePath)
                        if  image == nil{
                            image = UIImage(contentsOfFile: temImagePath)
                        }
                        collectionCell.imageView.image = image
                    }
                }
            }
            
            collectionCell.title = titlesGroup?[itemIndex]
            if !collectionCell.hasConfigured{
                collectionCell.titleLabelBackgroundColor = self.titleLabelBackgroundColor
                collectionCell.titleLabelHeight = self.titleLabelHeight
                collectionCell.titleLabelTextAlignment = self.titleLabelTextAlignment
                collectionCell.titleLabelTextFont = self.titleLabelTextFont
                collectionCell.titleLableTextColor = self.titleLabelTextColor
                collectionCell.hasConfigured  = true
                collectionCell.imageView.contentMode = self.bannerImageViewContentMode
                collectionCell.clipsToBounds = true
                collectionCell.onlyDisplayText = self.onlyDisplayText
            }
        }
        
        return cell
    }
    func setupClickItemOperationBlock(closure: CallBack) {
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        let index = self.pageControlIndexWithCurrentCellIndex(index: indexPath.row)
        self.delegate?.cycleScrollView(self, didSelectItemAt: index)
        if (self.clickItemOperationBlock != nil) {
            self.clickItemOperationBlock!(self, index)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollDirection == .horizontal && infiniteLoop {
            if scrollView.contentOffset.x >= CGFloat((totalItemCount - 1)) * (flowLayout?.itemSize.width)!  && infiniteLoop {
               
                scrollView.setContentOffset( CGPoint(x:CGFloat((totalItemCount/2 - 1))*(flowLayout?.itemSize.width)!, y: 0), animated: false)
            }
            if scrollView.contentOffset.x <= 0.0 && infiniteLoop{
                scrollView.setContentOffset( CGPoint(x:CGFloat((totalItemCount/2))*(flowLayout?.itemSize.width)!, y: 0), animated: false)
                
            }
        } else if scrollDirection == .vertical && infiniteLoop {
            if scrollView.contentOffset.y >= CGFloat((totalItemCount - 1)) * (flowLayout?.itemSize.height)!  && infiniteLoop {
                scrollView.setContentOffset( CGPoint(x:0, y: CGFloat((totalItemCount/2 - 1))*(flowLayout?.itemSize.height)!), animated: false)
            }
            if scrollView.contentOffset.y <= 0 && infiniteLoop{
                 scrollView.setContentOffset( CGPoint(x:0, y: CGFloat((totalItemCount/2))*(flowLayout?.itemSize.height)!), animated: false)
            }
        }
        let index = self.pageControlIndexWithCurrentCellIndex(index: self.currentIndex())
        pageControl?.currentPage = index

        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        if self.autoScroll {
            self.invalidateTimer()
        }

    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if self.autoScroll {
            self.setupTimer()
        }
    }
    
    override func layoutSubviews() {
        flowLayout?.itemSize = self.bounds.size
        if mainView?.contentOffset.x == 0 && totalItemCount != 0{
            var targetIndex = 0
            if self.infiniteLoop {
                targetIndex = totalItemCount / 2
            }else{
                targetIndex = 0
            }
            var scrollPosition = UICollectionViewScrollPosition.centeredHorizontally
            if scrollDirection == .vertical {
                scrollPosition = .centeredVertically
            }
            
            
             mainView?.scrollToItem(at: IndexPath(item: targetIndex, section: 0), at:scrollPosition, animated: false)
            
        }
        var size = CGSize(width: 0, height: 0)
        if self.imagePathsGroup != nil {
             size = CGSize(width: CGFloat((self.imagePathsGroup?.count)!) * self.pageControlDotSize.width * 1.5, height: self.pageControlDotSize.height)
        }
        
        var x = (self.width - size.width)*0.5
        if self.pageControlAliment == .AlimentRight{
            x = self.width - size.width - 10.0
        }
        let y = self.height - size.height - 10
        
        var pageControlFrame = CGRect(x: x, y: y, width: size.width, height: size.height)
        pageControlFrame.origin.y -= self.pageControlBottomOffset
        pageControlFrame.origin.x -= self.pageControlRightOffset
        self.pageControl?.frame = pageControlFrame

        if self.backgroundImageView != nil {
            self.backgroundImageView?.frame = self.bounds
        }
    }
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
