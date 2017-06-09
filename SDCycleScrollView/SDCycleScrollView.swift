//
//  SDCycleScrollView.swift
//  SDCycleScrollView
//
//  Created by 赵铭 on 2017/6/9.
//  Copyright © 2017年 zm. All rights reserved.
//

import UIKit

let ID = "cycleCell"

class SDCycleScrollView: UIView, UICollectionViewDelegate, UICollectionViewDataSource {
    
    var totalItemCount: Int = 0
    var infiniteLoop: Bool = true
    var imagePathsGroup: [String]?{
        get{
            return self.imagePathsGroup
        }
        set{
            
            if let array = newValue {
                totalItemCount = infiniteLoop ? array.count * 100 : array.count
                if array.count != 1 {
                    mainView?.isScrollEnabled = true
                }else{
                    mainView?.isScrollEnabled = false
                }

            }
            
            self.mainView?.reloadData()
        }
    }
    
    var backgroundImageView: UIImageView?
    var placeholderImage: UIImage?{
        get{
            return self.placeholderImage
        }
        set{
            if  backgroundImageView == nil {
                backgroundImageView = UIImageView()
            }
            backgroundImageView?.image = newValue
        }
    }
    var flowLayout: UICollectionViewFlowLayout?
    var mainView: UICollectionView?
    
    init(frame: CGRect, placeholderImage: UIImage?) {
        super .init(frame: frame)
        self.placeholderImage = placeholderImage
        self.setupMainView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupMainView()  {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.minimumLineSpacing = 0
        flowLayout.scrollDirection = UICollectionViewScrollDirection.horizontal
        self.flowLayout = flowLayout
        
        let mainView = UICollectionView(frame: self.bounds, collectionViewLayout: flowLayout)
        mainView.backgroundColor = UIColor.clear
        mainView.isPagingEnabled = true
        mainView.showsVerticalScrollIndicator = false
//        mainView.showsHorizontalScrollIndicator = false
        mainView .register(SDCollectionViewCell.self, forCellWithReuseIdentifier: ID)
        mainView.delegate = self
        mainView.dataSource = self
        mainView.scrollsToTop = false
        self.addSubview(mainView)
        self.mainView = mainView
        
    }
    
    

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int{
        return totalItemCount
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell{
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ID, for: indexPath)
        cell.backgroundColor = UIColor.red
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath){
        
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        
    }
    override func layoutSubviews() {
        flowLayout?.itemSize = self.bounds.size
    }    /*
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect) {
        // Drawing code
    }
    */

}
