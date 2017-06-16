//
//  SDCollectionViewCell.swift
//  SDCycleScrollView
//
//  Created by zm on 2017/6/9.
//  Copyright © 2017年 zm. All rights reserved.
//

import UIKit

class SDCollectionViewCell: UICollectionViewCell {
    var hasConfigured:Bool = false
    var title: String?{
        didSet{
            titleLabel.text = title
            if titleLabel.isHidden{
                titleLabel.isHidden = false
            }
        }
    }
    var titleLabel: UILabel
    var imageView: UIImageView
    var titleLabelBackgroundColor: UIColor?{
        didSet{
            titleLabel.backgroundColor = titleLabelBackgroundColor
        }
    }
    
    var titleLableTextColor: UIColor?{
        didSet{
            titleLabel.textColor = titleLableTextColor
        }
    }
    
    var titleLabelTextFont: UIFont? {
        didSet{
            titleLabel.font = titleLabelTextFont
        }
    }
    
    var titleLabelTextAlignment: NSTextAlignment = .left {
        didSet{
            titleLabel.textAlignment = titleLabelTextAlignment
        }
    }
    var titleLabelHeight: CGFloat = 0.0
    var onlyDisplayText: Bool = false
    override init(frame: CGRect) {
        imageView = UIImageView()
        titleLabel = UILabel()
        titleLabel.isHidden = true
        super.init(frame: frame)
        self.contentView.addSubview(imageView)
        self.contentView.addSubview(titleLabel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if  onlyDisplayText {
            titleLabel.frame = self.bounds
            
        }else{
            imageView.frame = self.bounds
            let titleLabelW = self.width
            let titleLabelH = titleLabelHeight
            let titleLabelY = self.height - titleLabelHeight
            titleLabel.frame = CGRect(x: 0, y: titleLabelY, width: titleLabelW, height: titleLabelH)
        }
    }
    
}
