//
//  UIViewExtension.swift
//  SDCycleScrollView
//
//  Created by zm on 2017/6/12.
//  Copyright © 2017年 zm. All rights reserved.
//

import Foundation
import UIKit

extension UIView{
    var height: CGFloat{
        get{
            return self.frame.size.height
        }
        set{
            var tem = self.frame
            tem.size.height = newValue
            self.frame = tem
        }
    }
    
    var width: CGFloat{
        get {
            return self.frame.size.width
        }
        set {
            var tem = self.frame
            tem.size.width = newValue
            self.frame = tem
            
        }
    }
    
    
    var left: CGFloat{
        get{
            return self.frame.origin.x
        }
        set{
            var  tem = self.frame
            tem.origin.x = newValue
            self.frame = tem
        }
    }
    
    var top: CGFloat{
        get{
            return self.frame.origin.y
        }
        set {
            var tem = self.frame
            tem.origin.y = newValue
            self.frame = tem
        }
    }
}
