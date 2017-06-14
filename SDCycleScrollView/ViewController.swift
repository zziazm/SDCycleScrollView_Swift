//
//  ViewController.swift
//  SDCycleScrollView
//
//  Created by 赵铭 on 2017/6/9.
//  Copyright © 2017年 zm. All rights reserved.
//

import UIKit

class ViewController: UIViewController, SDCycleScrollViewDelegate{
    
    
    
    
    
    var v: SDCycleScrollView?
    override func viewDidLoad() {
    super.viewDidLoad()
    self.view.backgroundColor = UIColor(red: 0.98, green: 0.98, blue: 0.98, alpha: 0.99)
    
    let backgroundView = UIImageView(image: UIImage(named: "005.jpg"))
    backgroundView.frame = self.view.bounds
    self.view.addSubview(backgroundView)
        
    let demoContainerView = UIScrollView(frame: self.view.bounds)
    demoContainerView.contentSize = CGSize(width: self.view.bounds.size.width, height: 1200)
    self.view.addSubview(demoContainerView)
        
    self.title = "轮播图demo"
    
    // 情景一：采用本地图片实现
        let imageNames = ["h1.jpg",
                          "h2.jpg",
                          "h3.jpg",
                          "h4.jpg",
                          "h7"] // 本地图片请填写全名
        // 情景二：采用网络图片实现
        let imagesURLStrings = [
        "https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
        "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
        "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
        ];
        
    // 情景三：图片配文字
        let titles = ["新建交流QQ群：185534916 ",
        "感谢您的支持，如果下载的",
        "如果代码在使用过程中出现问题",
        "您可以发邮件到gsdios@126.com"
        ]
        
        let w: CGFloat = self.view.bounds.size.width
    
        // >>>>>>>>>>>>>>>>>>>>>>>>> demo轮播图1 >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
       
        let  cycleScrollView = SDCycleScrollView(frame: CGRect(x: 0, y: 64, width: w, height: 180), shouldInfiniteLoop: true, imageNamesGroup: imageNames)
        cycleScrollView.delegate = self
        cycleScrollView.pageControlStyle = .StyleClassic
        cycleScrollView.scrollDirection = .vertical 
        demoContainerView.addSubview(cycleScrollView)

        
     
//    let v = SDCycleScrollView(frame: CGRect(x: 10, y: 100, width: 300, height: 300), placeholderImage: nil)
//    v.delegate = self
//    
//        v.clickItemOperationBlock = { (sc: SDCycleScrollView ,index: Int) -> Void in
//            print("block \(index)")
//    }
//     v.setupClickItemOperationBlock { (v, index) in
//        
//     }
//     v.backgroundColor = UIColor.gray
//     v.infiniteLoop = true
//        v.imagePathsGroup = ["https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
//                              "https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
//                               "http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"]
//     self.view.addSubview(v)
//     self.v = v
//     let b = UIButton(type:.custom)
//     b.frame = CGRect(x: 100, y: 500, width: 100, height: 50)
//     b.addTarget(self, action:#selector(test), for: .touchUpInside)
//     b.setTitle("aadfsfa", for: .normal)
//     b.backgroundColor = UIColor.black
//     self.view.addSubview(b)
    // Do any additional setup after loading the view, typically from a nib.
    }
    func cycleScrollView(_ cycleScrollView: SDCycleScrollView, didSelectItemAt index: Int) {
        print("delegate\(index)")
    }
    func test() {
        v?.mainView?.scrollToItem(at:  IndexPath(item: 200, section: 0), at: .centeredHorizontally, animated: true)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

