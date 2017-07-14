//
//  SDCycleScrollView.swift
//  SDCycleScrollView
//
//  Created by zm on 2017/6/9.
//  Copyright © 2017年 zm. All rights reserved.
//

import UIKit

private let rate = 500
private let ID = "cycleCell"

typealias CallBack = (_ cycleScrollView:SDCycleScrollView, _ index: Int) -> Void

@objc protocol SDCycleScrollViewDelegate {
 @objc optional func cycleScrollView(_ cycleScrollView: SDCycleScrollView, didSelectItemAt index: Int)
}

public enum SDCycleScrollViewPageContolAliment: Int{
    case AlimentRight, AlimentCenter
}

public enum SDCycleScrollViewPageContolStyle: Int{
    case StyleClassic,StyleNone
}

class SDCycleScrollView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    class func cycleScrollView(frame: CGRect, delegate: SDCycleScrollViewDelegate?,placeholderImage: UIImage?) -> SDCycleScrollView {
        let cycleScrollView = SDCycleScrollView(frame: frame)
        cycleScrollView.delegate = delegate
        cycleScrollView.placeholderImage = placeholderImage
        return cycleScrollView;
    }
   
    class func cycleScrollView(frame: CGRect, imageURLStringsGroup: [String]) -> SDCycleScrollView {
        let cycleScrollView = SDCycleScrollView(frame: frame)
        cycleScrollView.imageURLStringsGroup = imageURLStringsGroup
        return cycleScrollView;
    }
    
    class func cycleScrollView(frame: CGRect, imageNamesGroup:[String]) -> SDCycleScrollView {
        let cycleScrollView = SDCycleScrollView(frame: frame)
        cycleScrollView.localizationImageNamesGroup = imageNamesGroup
        return cycleScrollView;
    }
    
    class func cycleScrollViewWithFrame(frame: CGRect, shouldInfiniteLoop: Bool, imageNamesGroup: [String]) -> SDCycleScrollView {
        let cycleScrollView = SDCycleScrollView(frame: frame)
        cycleScrollView.infiniteLoop = shouldInfiniteLoop
        cycleScrollView.localizationImageNamesGroup = imageNamesGroup
        return cycleScrollView;
    }
    
    /// 网络图片 url string 数组
    var imageURLStringsGroup: [String]?{
        didSet{
            imagePathsGroup = imageURLStringsGroup
        }
    }
    
    ///每张图片对应要显示的文字数组
    var titlesGroup: [String]?{
        didSet{
            if let titles = titlesGroup {
                if  onlyDisplayText{
                    let tem = titles.map{_ in
                        ""
                    }
                    self.backgroundColor = UIColor.clear
                    self.imageURLStringsGroup = tem
                }
            }
        }
    }
    
    ///本地图片数组
    var localizationImageNamesGroup: [String]?{
        didSet{
            self.imagePathsGroup = localizationImageNamesGroup
        }
    }
    
    ///自动滚动间隔时间,默认2s
    var autoScrollTimeInterval: TimeInterval = 2

    ///是否无限循环,默认Yes
    var infiniteLoop: Bool = true

    ///是否无限循环,默认Yes
    var autoScroll: Bool = true{
        didSet{
            self.invalidateTimer()
            if autoScroll {
                self.setupTimer()
            }
        }
    }
    
    ///图片滚动方向，默认为水平滚动
    var scrollDirection: UICollectionViewScrollDirection = .horizontal {
        didSet{
            flowLayout?.scrollDirection = scrollDirection;
        }
    }

    weak var delegate: SDCycleScrollViewDelegate?

    ///block方式监听点击
    var clickItemOperationBlock: CallBack?

    ///轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill
    var bannerImageViewContentMode: UIViewContentMode = .scaleToFill

    ///占位图，用于网络未加载到图片时
    var placeholderImage: UIImage?{
        didSet{
            self.setupPlaceholderImage()
        }
    }
    
    ///是否显示分页控件
    var showPageControl: Bool = true {
        didSet{
            self.pageControl?.isHidden = !showPageControl
        }
    }
    ///是否在只有一张图时隐藏pagecontrol，默认为YES
    var hidesForSinglePage: Bool = true
    
    ///只展示文字轮播
    var onlyDisplayText: Bool = false
    
    ///pagecontrol 样式，默认为系统样式
    var pageControlStyle: SDCycleScrollViewPageContolStyle = .StyleClassic
    
    ///分页控件位置
    var pageControlAliment: SDCycleScrollViewPageContolAliment = .AlimentCenter

    ///分页控件距离轮播图的底部间距（在默认间距基础上）的偏移量
    var pageControlBottomOffset: CGFloat = 0.0
    
    ///分页控件距离轮播图的右边间距（在默认间距基础上）的偏移量
    var pageControlRightOffset: CGFloat = 0.0

    ///轮播文字label字体颜色
    var titleLabelTextColor: UIColor = UIColor.white

    ///轮播文字label字体大小
    var titleLabelTextFont: UIFont = UIFont.systemFont(ofSize: 14)
    
    ///轮播文字label背景颜色
    var titleLabelBackgroundColor:UIColor?
    
    ///轮播文字label高度
    var titleLabelHeight:CGFloat = 30.0
    
    ///轮播文字label对齐方式
    var titleLabelTextAlignment: NSTextAlignment = .left
    
    func invalidateTimer() {
        timer?.invalidate()
        timer = nil
    }
    
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
   
    var pageControlDotSize = CGSize(width: 10.0, height: 10.0)
    var pageControl: UIPageControl?
    var timer: Timer?
    var totalItemCount: Int = 0
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
    
    var backgroundImageView: UIImageView?
    
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
        
        if (self.imagePathsGroup?.count == 0 || self.onlyDisplayText) {
            return
        }
        
        if self.imagePathsGroup?.count == 1 && self.hidesForSinglePage {
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
    
    required public init?(coder aDecoder: NSCoder) {
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
        timer = Timer(timeInterval: autoScrollTimeInterval, target: self, selector: #selector(automaticScroll), userInfo: nil, repeats: true)
        RunLoop.current.add(timer!, forMode:.commonModes)
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
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
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
        self.delegate?.cycleScrollView?(self, didSelectItemAt: index)
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
    
    override public func layoutSubviews() {
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
