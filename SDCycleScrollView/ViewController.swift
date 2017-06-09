//
//  ViewController.swift
//  SDCycleScrollView
//
//  Created by 赵铭 on 2017/6/9.
//  Copyright © 2017年 zm. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
     let v = SDCycleScrollView(frame: CGRect(x: 10, y: 100, width: 300, height: 300), placeholderImage: nil)
     v.backgroundColor = UIColor.gray
     self.view.addSubview(v)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

